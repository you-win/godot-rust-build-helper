use gdnative::prelude::*;

#[derive(NativeClass)]
#[inherit(Node)]
struct TestNode;

#[methods]
impl TestNode {
    fn new(_base: &Node) -> Self {
        Self
    }

    #[method]
    fn _ready(&self) {
        godot_print!("Hello world!");
    }

    #[method]
    fn hello(&self) {
        godot_print!("HELLO");
    }
}

fn init(handle: InitHandle) {
    handle.add_class::<TestNode>();
}

godot_init!(init);
