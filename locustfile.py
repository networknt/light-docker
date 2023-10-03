from locust import HttpUser, task


class OAuthUser(HttpUser):

    @task
    def get_access_code(self):
        r = self.client.get("https://localhost:6881/oauth2/code?response_type=code&client_id=f7d42348-c647-4efb-a52d-4c5787421e72&redirect_uri=http://localhost:8080/authorization", auth=('admin', '12345'))
        print(r.text)
