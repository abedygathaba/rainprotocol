from django.contrib.auth.models import User, Group
from rest_framework import serializers
from .models import *


class Doctorserializer(serializers.Serializer):
    
    class Meta:
        model =Doctor
        fields = ('__all__')
        
class Recordserializer(serializers.Serializer):
    
    class Meta:
        model=Records
        fields = ('__all__')        