from locust import HttpUser, task

import logging
from urllib.parse import urlparse, parse_qs



class OAuthUser(HttpUser):
    @task
    def get_access_code(self):
        r = self.client.get(
            "/oauth2/code?response_type=code&client_id=f7d42348-c647-4efb-a52d-4c5787421e72&redirect_uri=http://localhost:8080/authorization",
            auth=('admin', '12345'),
            verify=False,
            allow_redirects=False)
        if r.status_code == 302:
            parsed_redirect = urlparse(r.headers['Location'])
            redirect_params = parse_qs(parsed_redirect.query)
            auth_code = redirect_params.get('code')[0]
            logging.info(f"Authorization_code: {auth_code}")
        else:
            logging.info("Auth_code endpoint did not redirect")
