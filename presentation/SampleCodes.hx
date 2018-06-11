// Routes

interface Root {
	@:get('/')
	@:get('/hello')
	function home():String;

	@:get
	var version:{versionNumber:Int, buildDate:Date};
	
	@:sub
	var users:UsersApi;
}

// Params
interface Root {
	@:get('/hello/$name')
	function home(name:String):String;

	@:get('/articles/$id')
	function getArticle(id:Int, query:{language:String}):Article;

	@:post('/articles')
	function createArticle(body:{title:String, content:String}):Article;

	@:post('/users')
	@:params(name in body)
	@:params(region in body)
	function createUser(name:String, region:String):User;
}

// Request & Response
interface Root {
	@:post('/users')
	function createUser(body:{id:Int, name:String}):User;
	
	@:get('/users/$id')
	function getUser(id:Int):{id:Int, name:String};
}

// Access Control
interface Root {
	@:get('/settings')
	@:restrict(user.isAdmin())
	function getSettings(user:User):Settings;
}

interface User {
	function isAdmin():Promise<Bool>;
}

class Session {
	var header:IncomingRequestHeader;
	
	public function new(header)
		this.header = header;
	
	public function getUser():Promise<Option<User>> {
		return switch header.byName(AUTHORIZATION) {
			case Success(value): 
				var id = parseAuthHeader(value);
				Some(new User(id));
			case Failure(_):
				None;
		}
	}
}

// Remote

var httpClient = new JsClient();
var endpoint = new RemoteEndpoint(new Host('localhost', 9002))
var remote = new Remote<Root>(client, endpoint);
remote.createUser('Kevin', 'HK').handle(function(o) switch o {
	case Success(user): $type(user); // User
	case Failure(err): trace(err);
});
