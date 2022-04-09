from django.db import models

# Create your models here.
class Doctor(models.Model):
    fullname = models.CharField(max_length=300)
    specializations = models.CharField(max_length=300)
    hospital = models.CharField(max_length=300)
    location = models.CharField(max_length=255)
    
    def __str__(self):
        return self.fullname



class Records(models.Model):
    full_name = models.CharField(max_length=270)
    dateOfBirth = models.DateField()
    GENDER_CHOICES = (
        ('M', 'Male'),
        ('F', 'Female'),
    )

    gender = models.CharField(max_length=1, choices=GENDER_CHOICES)
    doctor = models.ForeignKey(Doctor,  on_delete=models.CASCADE)
    
    def __str__(self):
        return self.full_name
    