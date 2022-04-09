from django.db import models
from cloudinary.models import CloudinaryField
from django.contrib.auth.models import User

# Create your models here.

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    businessName = models.CharField(max_length=200)
    location = models.CharField(max_length=200)
    bio = models.TextField(max_length=500, blank=True)
    profile_pic = CloudinaryField('image')
    created_at = models.DateTimeField(auto_now_add=True)
    

    def __str__(self):
        return self.user  
    