use Rack::Static,
  :urls => [],
  :root => "public"

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'application/atom+xml',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('public/index.xml', File::RDONLY)
  ]
}
