package;

import tink.http.Response;
import tink.http.containers.*;
import tink.web.routing.*;

class Server {
	static function main() {
		var container = new NodeContainer(8002);
		var root = new Root();
		var router = new Router<Root>(root);
		container.run(function(req) return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError));
	}
}
