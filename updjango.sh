# Updates GRORE from Git Repostory in a pseudo production environement
# Run as root
iset -e
IFS=$'\n'
commands=$(cat <<EOF
cd /home/django/grore-django-app/
sudo -u django -g users git pull
sudo -u django -g users /home/django/venv/bin/pip install -r /home/django/grore-django-app/requirements.txt
sudo -u django -g users /home/django/venv/bin/python  /home/django/grore-django-app/manage.py makemigrations
sudo -u django -g users /home/django/venv/bin/python  /home/django/grore-django-app/manage.py migrate
sudo -u django -g users /home/django/venv/bin/python  /home/django/grore-django-app/manage.py collectstatic --noinput
cd
systemctl restart django
EOF
)
for command in $commands
do
  echo $command
  eval $command
  echo "DONE $command"
  echo "----------------------------------------------------------------------------------------"
done
