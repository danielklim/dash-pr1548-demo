from dash.testing.application_runners import ThreadedRunner

class ThreadedRunnerWrapper(ThreadedRunner):

	@classmethod
	def cast(cls, some_a: ThreadedRunner):
		assert isinstance(some_a, ThreadedRunner)
		some_a.__class__ = cls
		assert isinstance(some_a, ThreadedRunnerWrapper)
		some_a.host = 'localhost'
		some_a.port = 8080
		return some_a

	@property
	def url(self):
		"""The default server url."""
		return "http://{}:{}".format(self.host, self.port)
