# Deploying to Render

This guide will help you deploy your Rails application to Render.

## Prerequisites

1. A [Render account](https://render.com) (free tier works)
2. Your code pushed to a Git repository (GitHub, GitLab, or Bitbucket)
3. Your Rails master key

## Step 1: Get Your Rails Master Key

Run this command to see your master key:

```bash
cat config/master.key
```

**Important:** Keep this key secret! You'll need it in Step 3.

## Step 2: Push Your Code to Git

Make sure all your changes are committed and pushed:

```bash
git add .
git commit -m "Add Render deployment configuration"
git push origin main
```

## Step 3: Deploy to Render

### Option A: Using Blueprint (Automatic)

1. Go to [Render Dashboard](https://dashboard.render.com/)
2. Click **"New +"** → **"Blueprint"**
3. Connect your Git repository
4. Render will automatically detect `render.yaml` and create:
   - PostgreSQL database
   - Web service
5. **Important:** Add environment variables:
   - Go to your web service settings
   - Add `RAILS_MASTER_KEY` with the value from Step 1

### Option B: Manual Setup

1. **Create Database:**
   - Click **"New +"** → **"PostgreSQL"**
   - Name: `bookingexperts-db`
   - Plan: Free (or your choice)
   - Click **"Create Database"**

2. **Create Web Service:**
   - Click **"New +"** → **"Web Service"**
   - Connect your Git repository
   - Configure:
     - **Name:** `bookingexperts-web`
     - **Environment:** `Ruby`
     - **Build Command:** `./bin/render-build.sh`
     - **Start Command:** `bundle exec puma -C config/puma.rb`
     - **Plan:** Free (or your choice)

3. **Add Environment Variables:**
   - `DATABASE_URL` → Link to your PostgreSQL database
   - `RAILS_ENV` → `production`
   - `RAILS_MASTER_KEY` → Your master key from Step 1
   - `RAILS_LOG_TO_STDOUT` → `enabled`
   - `RAILS_SERVE_STATIC_FILES` → `enabled`

## Step 4: Wait for Deployment

- Render will:
  1. Clone your repository
  2. Run `bundle install`
  3. Build Tailwind CSS
  4. Precompile assets
  5. Run migrations
  6. Start your Rails server

This takes 3-5 minutes.

## Step 5: Access Your App

Once deployed, Render will give you a URL like:
```
https://bookingexperts-web.onrender.com
```

## Default Admin Credentials

- **Email:** admin@bookingexperts.com
- **Password:** admin123

**⚠️ Change these immediately in production!**

## Troubleshooting

### Build Fails
- Check build logs in Render dashboard
- Make sure `bin/render-build.sh` is executable

### Database Connection Errors
- Verify `DATABASE_URL` is set correctly
- Check database is in the same region as web service

### Assets Not Loading
- Verify `RAILS_SERVE_STATIC_FILES=enabled`
- Check build logs to ensure assets compiled

### SSL Errors
- Render provides free SSL automatically
- Make sure `force_ssl = true` in `config/environments/production.rb`

## Updating Your App

Push changes to your Git repository:

```bash
git push origin main
```

Render will automatically redeploy!

## Running Commands

Use Render Shell to run commands:

```bash
# Access Rails console
bundle exec rails console

# Run migrations manually
bundle exec rails db:migrate

# Rebuild Tailwind
bundle exec rails tailwindcss:build
```

## Database Backups

Render automatically backs up your database. You can restore from the dashboard.

## Costs

- **Free Tier:**
  - Web service spins down after 15 minutes of inactivity
  - Database has 90-day retention
  
- **Paid Plans:**
  - Always-on web service
  - Better database performance
  - More storage

## Support

- [Render Documentation](https://render.com/docs)
- [Rails on Render Guide](https://render.com/docs/deploy-rails)

