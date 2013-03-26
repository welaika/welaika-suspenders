ActionController::Base.send :include, BasicPresenter::Helpers
ActionController::Base.send :helper_method, :present
ActionController::Base.send :helper_method, :present_collection
