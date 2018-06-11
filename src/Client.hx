package;

import tink.web.proxy.Remote;
import tink.http.clients.*;
import tink.url.Host;

using tink.CoreApi;

class Client {
	static function main() {
		var remote = new Remote<Root>(
			#if nodejs
				new NodeClient(),
			#elseif js
				new JsClient(),
			#elseif sys
				new SocketClient(),
			#end
			new RemoteEndpoint(new Host('localhost', 8002))
		);
		
		remote.now().handle(function(o) switch o {
			case Success(now): 
				// $type(now);
				trace(now);
			case Failure(err):
				trace(err);
		});
		
		remote.users().create('Kevin').handle(function(o) switch o {
			case Success({id: id}): 
				trace('User ID: $id');
				remote.users().get(id).handle(function(o) trace(o.sure()));
			case Failure(err):
				trace(err);
		});
	}
}