cd /sources
tar xf setuptools-69.1.0.tar.gz
cd setuptools-69.1.0

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist setuptools