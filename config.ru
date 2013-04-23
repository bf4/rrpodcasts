use Rack::Static,
  :urls => [],
  :root => "."

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'application/atom+xml',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('index.xml', File::RDONLY)
  ]
}
