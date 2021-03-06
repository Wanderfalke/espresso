module ECoreTest__Canonical
  module Actions
    def index
     [rq.path, canonical?].inspect
    end

    def post_eatme
     [rq.path, canonical?].inspect
    end
  end
  
  class App < E
    map '/root', '/cms', '/pages'
    include Actions
  end

  class RemountApp < E
    map '/root', '/cms', '/pages'
    include Actions
  end


  Spec.new App do
    Testing 'without remap' do
      get
      is(last_response).ok?
      expect(last_response.body) == ['/root/', nil].inspect

      get '/cms'
      is(last_response).ok?
      expect(last_response.body) == ["/cms", "/root"].inspect

      post '/cms/eatme'
      is(last_response).ok?
      expect(last_response.body) == ["/cms/eatme", "/root/eatme"].inspect

      get '/pages'
      is(last_response).ok?
      expect(last_response.body) == ["/pages", "/root"].inspect

      post '/pages/eatme'
      is(last_response).ok?
      expect(last_response.body) == ["/pages/eatme", "/root/eatme"].inspect
    end
  end

  Spec.new self do
    app RemountApp.mount('/new-root', '/new-canonical')
    map RemountApp.base_url

    Testing 'with remap' do
      get
      is(last_response).ok?
      expect(last_response.body) == ['/new-root/root/', nil].inspect

      get '/cms'
      is(last_response).ok?
      expect(last_response.body) == ["/cms", "/new-root/root"].inspect

      post '/cms/eatme'
      is(last_response).ok?
      expect(last_response.body) == ["/cms/eatme", "/new-root/root/eatme"].inspect

      get '/pages'
      is(last_response).ok?
      expect(last_response.body) == ["/pages", "/new-root/root"].inspect

      post '/pages/eatme'
      is(last_response).ok?
      expect(last_response.body) == ["/pages/eatme", "/new-root/root/eatme"].inspect
    end
  end

end
