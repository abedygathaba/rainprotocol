from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static


urlpatterns = [
    path('doctor/', views.DoctorList.as_view()),
    path('doctor/<int:pk>',views.DoctorDetail.as_view()),
    path('records/', views.RecordList.as_view()),
    path('records/<int:pk>',views.RecordDetail.as_view()),
    
    
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)