**English version available here → [README_EN.md](README_EN.md)**

<h2>Uruuru – 多言語対応フリマアプリ</h2>

1. サービス概要

Uruuru は、日本に住む外国人でも安心して使えるフリマアプリを目指して、私が個人で開発したWebサービスです。

日本のフリマアプリは便利ですが、外国人にとっては
「日本語」「住所入力」「登録手続き」などがハードルになることがあります。

そうした不便を少しでも減らしたいと思い、実際の生活体験をもとに設計・実装しました。

⸻

2. 開発背景

私は日本で生活する中で、いくつかの使いづらさを感じました。

・商品説明を日本語で書くのが難しい
・郵便番号からの住所入力ルールが分かりづらい
・英語UIがほとんど用意されていない
・登録フローが複雑

「もし外国人の立場から設計されたフリマがあったらどうなるか？」
という視点で、このサービスを開発しました。

単なる機能実装ではなく、「外国人がつまずくポイント」を意識して設計しています。

⸻

3. サービスURL

https://uru-uru.com
（採用担当者用ログインあり）

⸻

4. 主な特徴（現状実装済）

🔐 ログイン・認証
	•	Facebookログイン
	•	Deviseによるメールアドレスログイン
	•	Recruiter向けデモログイン

🌍 UI 多言語対応
	•	英語 / 日本語 / シンハラ語
	•	i18nによる画面・メールの切り替え

🤖 AI 商品説明補助（OpenAI）

	・入力内容をもとに箇条書き形式の商品説明を生成
	・APIキー未設定時のフォールバック処理あり

🏠 住所入力補助

	・ZipCloud APIによる郵便番号自動補完

🛍️ 出品〜購入
	・商品出品 / 編集 / 削除
	・カテゴリ・ブランド別一覧表示
	・カート → 注文作成

📦 配送・送料計算
	•	都道府県別の送料ロジック
	•	Order作成時に自動計算
	•	Order確認メールの送信

💳 決済（Stripe）
	•	Stripe Checkout
	•	Apple Pay / クレジットカード対応
	•	Webhookによる決済状態管理

💬 メッセージ（買い手・売り手チャット）
	•	1対1メッセージ
	•	モバイル向けレイアウト最適化

✉️ 注文完了メール
	•	i18n対応
	•	購入情報 / 配送先を通知

⸻

4.5. 画面イメージ（Screenshots）

主要な画面のスクリーンショットを掲載しています。
各画像は /docs/screenshots/ 配下に保存しています。

### ホーム画面（デスクトップ）
![ホーム画面](docs/screenshots/home_page.png)

### 商品詳細ページ
![商品詳細](docs/screenshots/product_detail.png)

### 商品出品フォーム（AI説明生成つき）
![商品出品](docs/screenshots/product_creation.PNG)

### Stripe 決済画面（モバイル）
![Stripe Checkout](docs/screenshots/stripe_checkout.PNG)

### 住所自動入力（ZipCloud）
![住所自動入力](docs/screenshots/address_autofill.jpeg)

### メッセージ機能（モバイル）
![チャット画面](docs/screenshots/chat_screen.PNG)
⸻

5. 使用技術

フロントエンド
	•	HTML / ERB
	•	Tailwind CSS v4
	•	Stimulus（小さなUI操作をモジュール単位で管理）
	•	Turbo

	JavaScriptは最小限にし、Rails標準機能を中心に実装しています。

バックエンド
	•	Ruby 3.x
	•	Ruby on Rails 7.x
	•	PostgreSQL

	Railsの基本構成に沿って実装し、可読性と保守性を重視しています

外部API・サービス
	•	Facebook OAuth（ログイン）
	•	OpenAI API（商品説明補助）
	•	AWS S3（画像アップロード）
	•	ZipCloud（住所検索）
	•	Stripe Checkout（決済）

	外部APIは例外処理を入れ、安全に動作するよう設計しています。

インフラ / 本番環境
	・AWS（ECS Fargate / ALB / RDS / S3）
	・Docker
	・GitHub（コード管理）

	コンテナ化し、ECSで本番運用しています。
	ALBを通してHTTPS通信を行い、RDS(PostgreSQL)を利用しています。

⸻

6. アーキテクチャと設計方針
	
	設計では「シンプルで理解しやすいコード」を意識しました。

	・MVCに忠実な構成
	・Controllerはできるだけ薄く保つ
	・ビジネスロジックはModelまたはServiceへ分離

	例：

	・Orders::CreateFromCart
	・Products::GenerateDescription

	責務が大きくなりすぎないように整理しています。

	また、

	・Modelはscopeやvalidationを明確に定義
	・Viewにロジックを書かない（Helperで整理）
	・i18nで3言語を一元管理
	・配送ロジックはOrder関連クラスに集約

	Rails標準機能を優先し、過度な抽象化や複雑な設計は避けています。

⸻

7. ER 図

![ER図](docs/uruuru-erd-v2.svg)

⸻

9. 開発者

脇 ラクシカ
Ruby on Rails 開発者
静岡 / 日本
使用言語: 英語 / 日本語 / シンハラ語

## 開発環境での実行方法（任意）

```bash
git clone https://github.com/lakshikaedm/uruuru.git
cd uruuru
bundle install
bin/rails db:setup
bin/dev
