# ZerviOS Troubleshooting Guide

## Quick Diagnostic Checklist

When encountering issues, run through this checklist systematically:

### 1. Version Compatibility Check
```bash
# Check Payload version
cd src/payload
npm list payload

# Should show: payload@2.5.0
# If showing v3.x, you have a version mismatch!
```

### 2. Configuration Validation
```bash
# Check payload.config.ts imports
grep -n "import.*payload" src/payload/payload.config.ts

# Should see:
# import { buildConfig } from 'payload/config'
# NOT: import { buildConfig } from 'payload'
```

### 3. Dependency Verification
```bash
# Check required v2 packages
cd src/payload
npm list @payloadcms/bundler-webpack @payloadcms/richtext-slate

# Both should be installed and v1.x
```

## Common Error Patterns

### `ERR_MODULE_NOT_FOUND: Cannot resolve module '@payloadcms/db-mongodb'`

**Cause**: Version mismatch - using v3 package names in v2 project

**Solution**:
1. Check `payload.config.ts` imports
2. Use `mongooseAdapter` from `@payloadcms/db-mongoose` (v2)
3. NOT `mongodbAdapter` from `@payloadcms/db-mongodb` (v3)

### `Module not found: Can't resolve '@payloadcms/richtext-lexical'`

**Cause**: Lexical editor is v3 only

**Solution**:
1. Replace `lexicalEditor` with `slateEditor`
2. Install `@payloadcms/richtext-slate`
3. Update imports in `payload.config.ts`

### `Cannot find module 'payload/config'`

**Cause**: Wrong import path for buildConfig

**Solution**:
```typescript
// WRONG (v3 syntax)
import { buildConfig } from 'payload'

// CORRECT (v2 syntax)
import { buildConfig } from 'payload/config'
```

### `npm run dev` exits immediately with code 0

**Cause**: Missing compiled TypeScript files

**Solution**:
```bash
cd src/payload
npm run build  # Compile TypeScript first
npm run dev    # Then start dev server
```

### Docker container port conflicts

**Cause**: Ports 3000, 3001, or 27017 already in use

**Solution**:
```bash
# Stop all containers
docker-compose down

# Check what's using the ports
netstat -ano | findstr "3000 3001 27017"

# Kill processes if needed
taskkill /PID <process_id> /F

# Restart containers
docker-compose up -d
```

## Systematic Debugging Process

### Step 1: Identify the Error
1. Read the complete error message
2. Note the exact module/file causing issues
3. Check if it's a build-time or runtime error

### Step 2: Version Check
1. Verify Payload version: `npm list payload`
2. Check if error mentions v3-specific packages
3. Confirm configuration syntax matches version

### Step 3: Configuration Audit
1. Review `payload.config.ts` imports
2. Check `package.json` dependencies
3. Verify all packages are v2-compatible

### Step 4: Clean Build
1. Clear node_modules: `rm -rf node_modules`
2. Clear package-lock: `rm package-lock.json`
3. Fresh install: `npm install`
4. Build: `npm run build`

### Step 5: Test Incrementally
1. Start with minimal config
2. Add features one by one
3. Test after each addition

## Environment-Specific Issues

### Windows Development

**Line Ending Issues**:
```bash
# Configure Git to handle line endings
git config core.autocrlf true
```

**PowerShell Execution Policy**:
```powershell
# If scripts won't run
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Docker Desktop Issues**:
1. Ensure Docker Desktop is running
2. Check WSL2 integration is enabled
3. Verify file sharing permissions

### Network Issues

**npm Registry Timeouts**:
```bash
# Try different registry
npm config set registry https://registry.npmjs.org/

# Or use yarn
yarn install
```

**Corporate Firewall**:
```bash
# Configure proxy if needed
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy http://proxy.company.com:8080
```

## Prevention Strategies

### Before Starting Development

1. **Version Lock**:
   ```json
   {
     "engines": {
       "node": ">=18.0.0",
       "npm": ">=8.0.0"
     }
   }
   ```

2. **Dependency Audit**:
   ```bash
   npm audit
   npm outdated
   ```

3. **Configuration Validation**:
   ```bash
   # Test config syntax
   npx tsc --noEmit
   ```

### During Development

1. **Frequent Testing**:
   - Test after each major change
   - Keep working states in Git
   - Document configuration decisions

2. **Error Documentation**:
   - Screenshot error messages
   - Note exact steps to reproduce
   - Document solutions immediately

3. **Version Control**:
   - Commit working configurations
   - Tag stable releases
   - Use descriptive commit messages

## Emergency Recovery

### If Everything Breaks

1. **Reset to Last Working State**:
   ```bash
   git stash
   git checkout HEAD~1  # Go back one commit
   npm install
   npm run build
   ```

2. **Nuclear Option - Fresh Start**:
   ```bash
   # Backup your work first!
   git add .
   git commit -m "Backup before reset"
   
   # Reset everything
   rm -rf node_modules package-lock.json
   git checkout main
   npm install
   ```

3. **Container Reset**:
   ```bash
   docker-compose down -v  # Remove volumes too
   docker system prune -f  # Clean up
   docker-compose up --build
   ```

## Getting Help

### Internal Resources
1. [Post-Mortem Analysis](./POST_MORTEM_PAYLOAD_V2_MIGRATION.md)
2. [Development Guide](./DEVELOPMENT.md)
3. Project Git history for working configurations

### External Resources
1. [Payload v2 Documentation](https://payloadcms.com/docs/2.x/getting-started/what-is-payload)
2. [Payload Discord Community](https://discord.gg/payload)
3. [GitHub Issues](https://github.com/payloadcms/payload/issues)

### When to Escalate
- Error persists after following all troubleshooting steps
- Configuration works locally but fails in different environment
- Security-related issues
- Performance problems affecting development

---

**Remember**: Most issues are configuration or version-related. Always check compatibility first!