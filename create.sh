#!/usr/bin/bash

which python3

if [ $? == 0 ];then
	echo "Python exists"
	echo "Installing django"
	sudo apt-get install python3-pip > pip.logs
	echo "pip installed"
	which pip
	pip install django > django.logs
        echo "django installed"
        echo "Project name:"
        read project_name
        echo "App name:"
        read app_name
	django-admin startproject $project_name
	cd $project_name
	django-admin startapp $app_name
	cd $app_name
	#the file blueprint stuff
	#create templaets and app
	mkdir -p templates/$app_name
        mkdir -p static/$app_name
	cat ../../blueprints/app_views.py >> views.py 
	cat ../../blueprints/app_urls.py >> urls.py
	cd ..
	cd $project_name
	sed -i "/^INSTALLED_APPS = \[/a\ \ \ \ '$app_name'," settings.py
        echo -e "\nMEDIA_URL='/files/'\nMEDIA_ROOT='files'\nSTATICFILES_DIRS=[BASE_DIR / 'files']" >> settings.py
	echo -e "\nfrom django.urls import path,include\nfrom django.conf.urls.static import static\nfrom django.conf import settings" >> urls.py
	echo -e "urlpatterns +=[path('',include('$app_name.urls'))] + static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)" >> urls.py
	cd ..
	python3 manage.py makemigrations >> migrations.logs && python3 manage.py migrate >> migrate.logs
	echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@gmail.com', 'admin123')" | python3 manage.py shell
	echo "Note:Created an admin database,check admin_info for more information"
	echo "Project created"
        echo " Server listening on port http://127.0.0.1:8000/"

	python3 manage.py runserver >> server.logs
else
	echo "Python not found"

fi
