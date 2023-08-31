import tempfile
from unittest.mock import MagicMock, patch

from django.test import TestCase


# Create your tests here.
class SimpleTest(TestCase):
    @patch("Forum.views.boto3.client")
    def test_post_with_or_without_image(self, client: MagicMock):
        s3 = MagicMock()
        client.return_value = s3
        s3.upload_fileobj.return_value = ""
        s3.put_object_acl.return_value = ""

        with tempfile.NamedTemporaryFile(suffix=".jpg", delete=False) as temp_file:
            temp_file.write(b"Fake image content")
            temp_file_path = temp_file.name

        self.client.force_login(self.superuser)
        with open(temp_file_path, "rb") as file_obj:
            res = self.client.post(
                reverse("post-list"),
                data={
                    "title": "test",
                    "topic": 1,
                    "content": "test",
                    "image": file_obj,
                },
            )
            data = json.loads(res.content)
            print(data)

        s3.upload_fileobj.assert_called_once()
        s3.put_object_acl.assert_called_once()
