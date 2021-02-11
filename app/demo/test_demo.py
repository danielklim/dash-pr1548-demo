# https://dash.plotly.com/testing
import dash
import dash_html_components as html
from .threaded_runner_wrapper import ThreadedRunnerWrapper

def muh_setup(dash_duo):
	app = dash.Dash(__name__)
	app.layout = html.Div(id="nully-wrapper", children=0)
	dd = dash_duo
	dd.server = ThreadedRunnerWrapper.cast(dd.server)
	return app, dd

def test_success(dash_duo):
	app, dd = muh_setup(dash_duo)
	dd.server.host = 'dash'
	muh_test(app, dd)

def test_fail(dash_duo):
	app, dd = muh_setup(dash_duo)
	dd.server.host = 'localhost'
	muh_test(app, dd)

def muh_test(app, dash_duo):
	dash_duo.start_server(app, host = 'dash', port = 8080)
	dash_duo.wait_for_text_to_equal("#nully-wrapper", "0", timeout=1)
	assert dash_duo.find_element("#nully-wrapper").text == "0"
