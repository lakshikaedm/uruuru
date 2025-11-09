# Chat: Buyer–Seller Conversations (MVP)

> **Document policy**
>
> - Source of truth: **English** (below).
> - Translation: **Japanese** section mirrors the English. If they diverge, follow English.
> - Scope: MVP only. Revisit after release.

---

## English Version (Source of Truth)

### 1) Purpose
Enable a private, text-only conversation between a buyer and the seller about a specific product.

### 2) In Scope (MVP)
- Start a conversation from a product page (buyer → seller).
- One conversation per unique triple: (product_id, buyer_id, seller_id).
- List my conversations (buyer or seller).
- Post plain text messages inside a conversation.
- Non-JS (full-page POST/redirect). Turbo OK, no ActionCable.

### 3) Out of Scope (MVP)
- Images/files, emojis, read receipts, typing indicators.
- Real-time updates (ActionCable), notifications.
- Delete/archive/block/report.
- Group chats or multiple sellers per product.

### 4) Actors & Roles
- **Buyer**: authenticated user who is not the product owner.
- **Seller**: product owner (authenticated).
- **Unauthorized user**: anyone else → cannot view/post.

### 5) Data Model (names are indicative)
- **Conversation**: `product_id`, `buyer_id`, `seller_id`, timestamps.
  - Uniqueness: composite `[product_id, buyer_id, seller_id]`.
  - Associations: belongs_to `product`, `buyer` (User), `seller` (User); has_many `messages`.
- **Message**: `conversation_id`, `user_id`, `body:text`, timestamps.
  - Associations: belongs_to `conversation`, belongs_to `user`.
  - Ordering: default by `created_at ASC`.

### 6) Permissions & Security
- Only `buyer` or `seller` of a conversation can:
  - View the conversation.
  - Create messages in it.
- Third parties: 404 (or 403) on show/create.
- Validation: `body` presence and reasonable max length (e.g., 1,000 chars).
- Server-side checks only; views stay dumb.

### 7) Routes (MVP)
POST   /conversations               
# create (idempotent: find-or-create by triple)
GET    /conversations               
# index (only my conversations)
GET    /conversations/:id           
# show (only if participant)
POST   /conversations/:id/messages  
# create message (only if participant)

### 8) UX (Non-JS)
- Product show page: “Message seller” button → creates/finds the conversation, redirects to show.
- Conversation show: message list (oldest → newest), textarea + submit.
- Index: simple list grouped by product; shows last message preview & timestamp.
- Errors: show inline validation errors; unauthorized → 404/403 with flash.

### 9) Acceptance Criteria (MVP)
- Buyer can start a conversation from a product page; it’s unique per (product, buyer, seller).
- Buyer and seller both see the conversation in their **/conversations**.
- Both can post messages; messages render in chronological order.
- Non-participants cannot access the conversation or post messages.
- Invalid message body shows an error; no message is created.

### 10) Non-Functional
- Keep controllers skinny; move rules to models/services.
- No background jobs. No additional gems.
- i18n strings optional; keep labels simple for now.

### 11) Open Questions (defer)
- Unread counts/badges?
- Attachments via Active Storage?
- Real-time updates with ActionCable?
- Archiving/deleting conversations?
- Product sold state behavior?

### 12) Test Plan (high level)
- **Model**: validations, associations, uniqueness, default order.
- **Request**: create/find conversation; authorization on show/create; index scoping; invalid message handling.
- **System (non-JS)**: buyer starts thread → seller replies; unauthorized user blocked.

---

## 日本語版（翻訳）

### 1) 目的
特定の商品について、購入者と出品者がプライベートにテキストのみでやり取りできるようにする。

### 2) 対象範囲（MVP）
- 商品ページから会話を開始（購入者→出品者）。
- 一意性：`(product_id, buyer_id, seller_id)` ごとに 1 会話。
- 自分の会話一覧の表示（購入者/出品者）。
- テキストメッセージの投稿。
- 非JS（フルページのPOST/リダイレクト）。Turboは可、ActionCableなし。

### 3) 対象外（MVP）
- 画像/ファイル、絵文字、既読、タイピング表示。
- リアルタイム更新（ActionCable）、通知。
- 削除/アーカイブ/ブロック/通報。
- 複数出品者やグループチャット。

### 4) 登場人物
- **購入者**：商品所有者ではない認証ユーザー。
- **出品者**：商品所有者（認証ユーザー）。
- **非参加者**：上記以外 → 閲覧・投稿不可。

### 5) データモデル（名称は例）
- **Conversation**：`product_id`, `buyer_id`, `seller_id`, timestamps  
  - 複合一意制約：`[product_id, buyer_id, seller_id]`  
  - 関連：`product`、`buyer`（User）、`seller`（User）に属す／`messages` を複数所持。
- **Message**：`conversation_id`, `user_id`, `body:text`, timestamps  
  - 関連：`conversation`、`user` に属す  
  - 並び順：`created_at ASC`（古い→新しい）

### 6) 権限・セキュリティ
- `buyer` または `seller` のみ：
  - 会話の閲覧
  - メッセージ投稿
- 第三者：show/create は 404（または 403）。
- バリデーション：`body` 必須、最大文字数（例：1,000字）。
- サーバーサイドで厳格にチェック。ビューは薄く。

### 7) ルーティング（MVP）
POST   /conversations               
# 作成（同一三つ組で idempotent）
GET    /conversations               
# 一覧（自分の会話のみ）
GET    /conversations/:id           
# 詳細（参加者のみ）
POST   /conversations/:id/messages  
# 投稿（参加者のみ）

### 8) UX（非JS）
- 商品詳細：［出品者にメッセージ］→ 会話を作成/再利用して詳細へリダイレクト。
- 会話詳細：メッセージ一覧（古→新）、テキストエリア＋送信。
- 一覧：商品ごとにグルーピング、最新メッセージの抜粋と時刻を表示。
- エラー：バリデーションを画面で表示。権限なしは 404/403＋フラッシュ。

### 9) 受け入れ基準（MVP）
- 購入者が商品ページから会話を開始でき、（商品・購入者・出品者）三つ組で一意になる。
- 購入者・出品者の両方が **/conversations** に会話を確認できる。
- 双方がメッセージ投稿でき、時系列（古→新）で表示される。
- 非参加者は閲覧・投稿できない。
- メッセージが不正な場合はエラー表示、作成されない。

### 10) 非機能
- コントローラは薄く、ルールはモデル/サービスへ。
- バックグラウンド処理なし。新規 Gem 追加なし。
- i18n は任意。文言はシンプルに。

### 11) オープンクエスチョン（後回し）
- 未読数・バッジ？
- Active Storage による添付？
- ActionCable でのリアルタイム化？
- 会話のアーカイブ/削除？
- 商品売却済み時の扱い？

### 12) テスト計画（概要）
- **Model**：バリデーション、関連、一意制約、デフォルト順序。
- **Request**：会話の作成/再利用、show/create の権限制御、一覧のスコープ、不正投稿の取り扱い。
- **System（非JS）**：購入者が開始→出品者が返信、第三者は拒否。

---
