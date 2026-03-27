# SSH Setup for GitHub

## 1. Generate SSH key

```bash
ssh-keygen -t ed25519 -C "your_email@example.com" # -C optional
```

---

## 2. Copy public key

```bash
cat ~/.ssh/id_ed25519.pub
```

---

## 3. Add to GitHub

Go to: https://github.com/settings/keys
Click **New SSH key** → paste(Key) → save

---

## 4. Enable SSH key

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

## 5. Test connection

```bash
ssh -T git@github.com
```

---

## Done

Use SSH instead of HTTPS:

```bash
git clone git@github.com:username/repo.git
```

