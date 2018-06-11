using tink.CoreApi;

class Root {
	public function new() {}
	
	@:get
	public function now() {
		return {
			now: Date.now().toString(),
		}
	}
	
	@:sub
	public var users:Users = new Users();
}

class Users {
	
	var list:Array<String> = [];
	
	public function new() {}
	
	@:post('/')
	@:params(name in body)
	public function create(name:String) {
		return {id: list.push(name)};
	}
	
	@:get('/$id')
	public function get(id:Int) {
		return switch list[id - 1] {
			case null: Failure(new Error(400, 'User Not Found'));
			case name: Success({name: name});
		}
	}
}