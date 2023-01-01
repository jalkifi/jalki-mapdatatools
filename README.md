docker build -t jalkiosrm .

docker run -t -v "${PWD}/data:/var/local/data" jalkiosm download_latest_data.sh

docker run -t -v "${PWD}/data:/var/local/data" jalkiosm extract_overpass_data.sh
