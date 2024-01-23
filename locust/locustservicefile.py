from locust import HttpUser, TaskSet, task, tag
from locust.exception import RescheduleTask
import logging
from uuid import uuid4
from urllib.parse import urlparse, parse_qs
from collections import namedtuple

SERVICES = set()
Service = namedtuple("Service", ["serviceName", "serviceId"]) #serviceSecret

class OAuthServiceRegistration(HttpUser):

    fixed_count = 1
    host = "https://localhost:6883"

    @task(1)
    class RegisterService(TaskSet):

        @task(1)
        @tag('correct', 'register', '200')
        def register_service_200(self):
            with self.client.post("/oauth2/service", data={
                "serviceType": "openapi",
                "serviceId": str(uuid4())[:8],  
                "serviceName": str(uuid4())[:32],
                "serviceDesc": str(uuid4()),
                "scope": "read write",
                "ownerId": "admin",
                "host": "lightapi.net"
                #redirect_uri?
            }, verify=False, allow_redirects=False, catch_response=True) as r:

                if r.status_code == 200:
                    t = r.json()
                    logging.info(f"Registered service: serviceName = {t['serviceName']}, serviceId = {t['serviceId']}")
                    #service secret?
                    SERVICES.add(Service(t['serviceName'], t['serviceId']))
                    r.success()
                else:
                    logging.info("Service registration did not return code 200")
                    r.failure("Service registration did not return code 200")
                self.interrupt()

        @task(1)
        @tag('error', 'register', '400')
        def register_service_400_serviceType(self):
            with self.client.post("/oauth2/service", data={
                "serviceType": "none",  # Error here
                "serviceId": str(uuid4())[:8], 
                "serviceName": str(uuid4())[:32],
                "serviceDesc": str(uuid4()),
                "scope": "read write",
                "ownerId": "admin",
                "host": "lightapi.net"
            }, verify=False, allow_redirects=False, catch_response=True) as r:

                if r.status_code == 400:
                    logging.info(f"Service Registration: error code 400 returned as expected (wrong serviceType)")
                    r.success()
                else:
                    failure_str = "Service Registration: did not return code 400 (serviceType). Instead: " + str(r.status_code)
                    logging.info(failure_str)
                    r.failure(failure_str)
                self.interrupt()

        @task(1)
        @tag('error', 'register', '400')
        def register_service_400_serviceProfile(self):
            with self.client.post("/oauth2/service", data={
                "serviceType": "openapi",
                "serviceProfile": "none",  # Error here
                "serviceId": str(uuid4())[:8],  # Adjust the serviceId generation as needed
                "serviceName": str(uuid4())[:32],
                "serviceDesc": str(uuid4()),
                "scope": "read write",
                "ownerId": "admin",
                "host": "lightapi.net"
            }, verify=False, allow_redirects=False, catch_response=True) as r:

                if r.status_code == 400:
                    logging.info(f"Service Registration: error code 400 returned as expected (wrong serviceProfile)")
                    r.success()
                else:
                    failure_str = "Service Registration: did not return code 400 (serviceProfile). Instead: " + str(r.status_code)
                    logging.info(failure_str)
                    r.failure(failure_str)
                self.interrupt()

        @task(1)
        @tag('error', 'register', '404')
        def register_service_404(self):
            with self.client.post("/oauth2/service", data={
                "serviceType": "openapi",
                "serviceProfile": "mobile",
                "serviceId": str(uuid4())[:8],  
                "serviceName": str(uuid4())[:32],
                "serviceDesc": str(uuid4()),
                "scope": "read write",
                "ownerId": "nouser",  # Error here
                "host": "lightapi.net"
            }, verify=False, allow_redirects=False, catch_response=True) as r:
                if r.status_code == 404:
                    logging.info("Service Registration: error code 404 returned as expected (non-existent user)")
                    r.success()
                else:
                    failure_str = "Service Registration: did not return code 404. Instead: " + str(r.status_code)
                    logging.info(failure_str)
                    r.failure(failure_str)
                self.interrupt()

    @task(1)
    class UpdateService(TaskSet):

        @task(1)
        @tag('correct','update','200')
        def update_service_200(self):
            try:
                c = SERVICES.pop()
            except KeyError:
                #logging.info("No services available to update")
                raise RescheduleTask()
            updated_data = {
                "serviceId": c.serviceId,
                "serviceType": "swagger",
                "serviceProfile": "mobile",
                "serviceName": str(uuid4())[:32],
                "serviceDesc": str(uuid4()),
                "scope": "read write",
                "ownerId" : "admin",
                "host": "lightapi.net"

            }

            with self.client.put("/oauth2/service", json=updated_data, verify=False, allow_redirects=False, catch_response=True) as r:
                if r.status_code == 200:
                    logging.info(f"Updated service: serviceId = {updated_data['serviceId']}")
                    SERVICES.add(Service(updated_data['serviceName'], c.serviceId)) #serviceSecret
                    r.success()
                else:
                    SERVICES.add(c)
                    logging.info(f"Service update failed with unexpected status code: {r.status_code}")
                    r.failure(f"Service update failed with unexpected status code: {r.status_code}")
                self.interrupt()

        @task(1)
        @tag('errror','update','404')
        def update_client_404(self):
            try:
                c = SERVICES.pop()
            except KeyError: #logging.info("No services available to update")
                raise RescheduleTask()
            
            updated_data = {
                "serviceId" : "",
                "serviceType" : "swagger",
                "serviceProfile": "mobile",
                "serviceName": str(uuid4())[:32],
                "serviceDesc": str(uuid4()),
                "scope": "read write",
                "ownerId" : "admin",
                "host": "lightapi.net"
            }
            
            with self.client.put("/oauth2/service", json=updated_data, verify=False, allow_redirects=False, catch_response=True) as r:
                if r.status_code == 404:
                    logging.info(f"service update without id failed as expected, 404")
                    SERVICES.add(c)
                    r.success()
                else:
                    SERVICES.add(c)
                    failstr = str(f"Unexpected status code when updating service without id: {r.status_code}")
                    logging.info(failstr)
                    r.failure(failstr)
            self.interrupt()

