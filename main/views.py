from rest_framework import permissions
from .serializers import *
from django.http import JsonResponse
from rest_framework import status
from django.http import Http404
from rest_framework.response import Response
from rest_framework.views import APIView

class DoctorList(APIView):  # get all Doctor
   

    def get(self, request, format=None):  # get all Doctors
        all_Subjects = Doctor.objects.all()
        serializers = Doctorserializer(all_Subjects, many=True)
        return Response(serializers.data)

    def post(self, request, format=None):  # create new Doctor
        serializers = Doctorserializer(data=request.data)
        if serializers.is_valid():
            serializers.save()
            return Response(serializers.data, status=status.HTTP_201_CREATED)
        return Response(serializers.errors, status=status.HTTP_400_BAD_REQUEST)


class DoctorDetail(APIView):  # get, update, delete single Doctor
   
    def get_object(self, pk):
        try:
            return Doctor.objects.get(pk=pk)
        except Doctor.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):  # get Doctor
        subject = self.get_object(pk)
        serializers = Doctorserializer(subject)
        return Response(serializers.data)

    def put(self, request, pk, format=None):  # update Doctor
        subject = self.get_object(pk)
        serializers = Doctorserializer(subject, data=request.data)
        if serializers.is_valid():
            serializers.save()
            return Response(serializers.data)
        return Response(serializers.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):  # delete Doctor
        subject = self.get_object(pk)
        subject.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class RecordList(APIView):  # get all record
   

    def get(self, request, format=None):  # get all  records
        all_Subjects = Records.objects.all()
        serializers = Recordserializer(all_Subjects, many=True)
        return Response(serializers.data)

    def post(self, request, format=None):  # create new record
        serializers = Recordserializer(data=request.data)
        if serializers.is_valid():
            serializers.save()
            return Response(serializers.data, status=status.HTTP_201_CREATED)
        return Response(serializers.errors, status=status.HTTP_400_BAD_REQUEST)


class RecordDetail(APIView):  # get, update, delete single record
   
    def get_object(self, pk):
        try:
            return Records.objects.get(pk=pk)
        except Records.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):  # get record
        subject = self.get_object(pk)
        serializers = Recordserializer(subject)
        return Response(serializers.data)

    def put(self, request, pk, format=None):  # update record
        subject = self.get_object(pk)
        serializers = Recordserializer(subject, data=request.data)
        if serializers.is_valid():
            serializers.save()
            return Response(serializers.data)
        return Response(serializers.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):  # delete record
        subject = self.get_object(pk)
        subject.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


