--- base state class to avoid null

BaseState = Class{}

function BaseState:init() end
function BaseState:exit() end
function BaseState:enter() end
function BaseState:update(dt) end
function BaseState:render() end