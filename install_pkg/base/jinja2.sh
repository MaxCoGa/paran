cd /sources
tar xf Jinja2-3.1.3.tar.gz
cd Jinja2-3.1.3

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Jinja2