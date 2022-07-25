from dotenv import find_dotenv, load_dotenv
import os

load_dotenv(find_dotenv('../../environment.env'))

URL_ITDASHBOARD = os.environ.get("urlITDashboard")
URL_SEARCH_ADVANCED = os.environ.get("urlSearchAdvanced")
AGENCY_WANTED = os.environ.get("agencyWanted")
OUTPUT = os.environ.get("outPut")
