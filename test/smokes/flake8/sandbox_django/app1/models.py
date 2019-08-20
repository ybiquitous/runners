from django.db import models
from logging import getLogger

logger = getLogger(__name__)


class User(models.Model):
    name = models.CharField(max_length=255)
    age = models.IntegerField()

    def say(self):
        print(ok)
        foo = 123
        return {
            'name': 123,
            'name': 124,
        }
