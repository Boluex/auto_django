from django.contrib import admin
from django.urls import path,include

url_path='todo_app.urls'
urlpatterns = [
    path('admin/', admin.site.urls),
    path('',include(url_path))
]
