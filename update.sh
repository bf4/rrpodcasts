#!/usr/bin/env bash --login
git pull --rebase origin master && \
    ruby extract_episodes.rb && \
    ruby build_episodes.rb
    git add episodes/ && \
    git commit -am 'Update feed'
    git push origin && \
    git push heroku
