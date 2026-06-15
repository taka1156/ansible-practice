# ansible-practice

VS Code の **Dev Container** を使って、Ansible の学習・検証を手軽に行うための練習用環境です。
仮想マシン(VM)を用意せずに、Docker コンテナだけで「Ansible 実行環境（bastion）」と「操作対象サーバー（target）」を構築し、すぐに Playbook の作成・実行を試せます。

## 特徴

- VS Code の Dev Containers 拡張機能で `Reopen in Container` するだけで環境構築が完了
- Ansible 実行環境（control node）と SSH 接続先（managed node）の2コンテナ構成
- 起動時に SSH 鍵ペアを自動生成・自動配布（手動でのキー生成・コピーが不要）
- `ansible-lint` / `secretlint` などのチェックツールを同梱
- 日本語ロケール（`ja_JP.UTF-8`）・タイムゾーン（`Asia/Tokyo`）をあらかじめ設定済み

## 前提条件

- Docker / Docker Compose
- Visual Studio Code
- VS Code 拡張機能 [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

## セットアップ

1. リポジトリをクローン
   
   ```bash
   git clone https://github.com/taka1156/ansible-practice.git
   cd ansible-practice
   ```
1. VS Code で開き、コマンドパレットから `Dev Containers: Reopen in Container` を実行
- `ansible-bastion`（Ansible 実行環境）と `ansible-target`（操作対象サーバー）の2コンテナが起動します
- `ansible-target` が SSH 鍵ペアを生成し、`ansible-bastion` 側に自動でコピーされます
1. コンテナ起動後、`ansible-bastion` 内のターミナルで作業します

## 使い方

### 疎通確認

```bash
make ping
```

`ansible -i ansible/inventory.ini ubuntu_servers -m ping` を実行し、`ansible-target` への接続を確認します。

### target サーバーへ SSH 接続

```bash
make ssh
```

### Playbook の実行例

```bash
ansible-playbook -i ansible/inventory.ini your_playbook.yml
```

### Lint

```bash
ansible-lint
```

## ディレクトリ構成

```
.
├── .devcontainer/
│   ├── devcontainer.json        # Dev Container 設定
│   ├── docker-compose.yml       # bastion / target の2コンテナ定義
│   ├── ansible_bastion/
│   │   └── Dockerfile           # Ansible 実行環境
│   ├── ansible_target/
│   │   ├── Dockerfile           # SSH 接続先サーバー
│   │   └── entrypoint.sh        # SSH鍵生成 & authorized_keys登録
│   └── scripts/
│       └── sync-ssh-key.sh      # target で生成した鍵を bastion 側へ同期
├── ansible/
│   └── inventory.ini            # インベントリ（ubuntu_servers グループ）
├── ansible.cfg                  # Ansible 設定（remote_user, 秘密鍵パス等）
├── Makefile                     # ssh / ping ショートカット
└── README.md
```

## 構成のポイント

|コンテナ             |役割          |内容                                                    |
|-----------------|------------|------------------------------------------------------|
|`ansible-bastion`|Ansible 実行環境|git, ansible, ansible-lint, secretlint, cloudflared など|
|`ansible-target` |操作対象サーバー    |openssh-server, python3, `ansible` ユーザー（NOPASSWD sudo）|

両コンテナは Docker ネットワーク `lab-net` で接続されており、`ansible-bastion` から `ansible-target` へホスト名 `ansible-target` で SSH 接続できます。

## 今後の予定

- [ ] サンプル Playbook の追加
- [ ] Role 構成のサンプル追加
- [ ] CI（GitHub Actions）での ansible-lint 実行
