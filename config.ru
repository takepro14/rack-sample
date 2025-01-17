# frozen_string_literal: true

app = proc do
  [
    200,
    { 'content-type' => 'text/plain' },
    ['Hello, Rack!']
  ]
end

run app
