#!/bin/bash

# DEKK Archive 로컬 환경 설정 스크립트

echo "🚀 DEKK Archive 로컬 환경 설정 중..."

# Ruby 3.1 경로 설정
export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"

# 테스트: Ruby 및 Bundle 버전 확인
echo "✅ Ruby 버전: $(ruby --version)"
echo "✅ Bundle 버전: $(bundle --version)"

# Jekyll 서버 실행
echo ""
echo "🌐 로컬 서버 시작 (http://localhost:4000)"
echo "⚠️  Ctrl+C로 종료할 수 있습니다"
echo ""

bundle exec jekyll serve
