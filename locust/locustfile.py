from locust import HttpUser, task
from locust.exception import RescheduleTask

import logging
from urllib.parse import urlparse, parse_qs
from uuid import uuid4
from collections import namedtuple

CLIENTS = set()
Client = namedtuple("Client", ["clientName", "clientId", "clientSecret"])


class OAuthClientRegistration(HttpUser):

    fixed_count = 1
    host = "https://localhost:6884"

    @task(1)
    def register_client(self):
        r = self.client.post("/oauth2/client", data=
        {
            "clientType": "public",  # TODO implement different types for different auth flows
            "clientProfile": "mobile",  # TODO put different if important?
            "clientName": str(uuid4())[:32],
            "clientDesc": str(uuid4()),
            "scope": "read write",  # TODO implement different scopes
            "redirectUri": "http://localhost:8000/authorization",
            "ownerId": "admin",  # TODO implement different users
            "host": "lightapi.net"
        }, verify=False, allow_redirects=False)

        if r.status_code == 200:
            r = r.json()
            logging.info(f"Registered client: clientName = {r['clientName']}, clientId = {r['clientId']},"
                         f" clientSecret = {r['clientSecret']}")
            CLIENTS.add(Client(r['clientName'], r['clientId'], r['clientSecret']))
        else:
            logging.info("Client registration did not return code 200")

    @task(0)
    def update_client(self):
        pass

    @task(1)
    def delete_client(self):
        try:
            c = CLIENTS.pop()
        except KeyError:
            raise RescheduleTask()
        r = self.client.delete(f"/oauth2/client/{c.clientId}", verify=False, allow_redirects=False)
        if r.status_code == 200:
            logging.info(f"Deleted client: clientName = {c.clientName}, clientId = {c.clientId},"
                         f" clientSecret = {c.clientSecret}")
        else:
            logging.info('Client deletion did not return code 200')
            CLIENTS.add(c)

    @task(0)
    def get_client(self):
        pass

    @task(0)
    def get_all_clients(self):
        pass

    @task(0)
    def link_service(self):
        pass

    @task(0)
    def delete_service(self):
        pass

    @task(0)
    def delete_all_services(self):
        pass

    @task(0)
    def get_service(self):
        pass

    @task(0)
    def get_all_services(self):
        pass


class OAuthUser(HttpUser):

    host = "https://localhost:6881"

    @task
    def get_access_code(self):
        r = self.client.get(
            "/oauth2/code?response_type=code&client_id=f7d42348-c647-4efb-a52d-4c5787421e72&redirect_uri=http://localhost:8080/authorization",
            auth=('admin', '123456'),
            verify=False,
            allow_redirects=False)
        if r.status_code == 302:
            parsed_redirect = urlparse(r.headers['Location'])
            redirect_params = parse_qs(parsed_redirect.query)
            auth_code = redirect_params.get('code')[0]
            logging.info(f"Authorization_code: {auth_code}")
        else:
            logging.info("Auth_code endpoint did not redirect")
