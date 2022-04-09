from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static


urlpatterns = [
    
    path('users/create/', views.UserCreate.as_view()), # create user
    path('login/', views.loginUser.as_view()), # login user
    path('logout/', views.logoutUser.as_view()), # logout user
    path('api/profiles/', views.Profile.as_view()), # list of profiles
    path('api/profiles/<int:pk>', views.ProfileDetail.as_view()), # single profile
    
    
]


if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,
                          document_root=settings.MEDIA_ROOT)