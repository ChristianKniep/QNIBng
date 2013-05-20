QNIBng
======

QNIB NextGeneration. OpenSM plugin that pushes stats to graphite (plain or via statsd)

Using the OpenSM plugin osmeventplugin as a starting point the metrics are pushed towards a graphite instance.
To get a better ease of use (the/some) metrics might be pushed through statsd which will provide the possibility of 
counting, timeing, etc.

Install
-------
First one needs to install graphite.
The easiest method might be using pip.
```
# Install python-pip, django, cairo, etc. depending on your distro
python-pip install whisper carbon graphite-web
cd /opt/graphite/
cp conf/carbon.conf.example conf/carbon.conf
cp conf/storage-schemas.conf.example conf/storage-schemas.conf
cat << \EOF > webapp/graphite/local_settings.py
DATABASES = {
    'default': {
        'NAME': '/opt/graphite/storage/graphite.db',
        'ENGINE': 'django.db.backends.sqlite3',
        'USER': '',
        'PASSWORD': '',
        'HOST': '',
        'PORT': ''
    }
}
EOF
PYTHONPATH=`pwd`/webapp:`pwd`/whisper python ./webapp/graphite/manage.py syncdb
/opt/graphite/bin/carbon-cache.py start
```
