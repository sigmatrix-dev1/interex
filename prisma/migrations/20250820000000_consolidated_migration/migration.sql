-- Consolidated Migration: All schema changes from 20250221233640_init through 20250702022824_add_fhir_submission_id
-- This migration replaces all previous migration files and represents the complete current schema

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "email" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "name" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "customerId" TEXT,
    "providerGroupId" TEXT,
    CONSTRAINT "User_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "User_providerGroupId_fkey" FOREIGN KEY ("providerGroupId") REFERENCES "ProviderGroup" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "UserImage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "altText" TEXT,
    "objectKey" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "userId" TEXT NOT NULL,
    CONSTRAINT "UserImage_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Password" (
    "hash" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    CONSTRAINT "Password_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Session" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "expirationDate" DATETIME NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "userId" TEXT NOT NULL,
    CONSTRAINT "Session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Permission" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "action" TEXT NOT NULL,
    "entity" TEXT NOT NULL,
    "access" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Role" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "Verification" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "type" TEXT NOT NULL,
    "target" TEXT NOT NULL,
    "secret" TEXT NOT NULL,
    "algorithm" TEXT NOT NULL,
    "digits" INTEGER NOT NULL,
    "period" INTEGER NOT NULL,
    "charSet" TEXT NOT NULL,
    "expiresAt" DATETIME
);

-- CreateTable
CREATE TABLE "Connection" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "providerName" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "userId" TEXT NOT NULL,
    CONSTRAINT "Connection_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Passkey" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "aaguid" TEXT NOT NULL,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "publicKey" BLOB NOT NULL,
    "userId" TEXT NOT NULL,
    "webauthnUserId" TEXT NOT NULL,
    "counter" BIGINT NOT NULL,
    "deviceType" TEXT NOT NULL,
    "backedUp" BOOLEAN NOT NULL,
    "transports" TEXT,
    CONSTRAINT "Passkey_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "baaNumber" TEXT,
    "baaDate" DATETIME,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "ProviderGroup" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "customerId" TEXT NOT NULL,
    CONSTRAINT "ProviderGroup_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Provider" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "npi" TEXT NOT NULL,
    "name" TEXT,
    "active" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "customerId" TEXT NOT NULL,
    "providerGroupId" TEXT,
    CONSTRAINT "Provider_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "Provider_providerGroupId_fkey" FOREIGN KEY ("providerGroupId") REFERENCES "ProviderGroup" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "UserNpi" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "userId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    CONSTRAINT "UserNpi_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "UserNpi_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "Submission" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT NOT NULL,
    "purposeOfSubmission" TEXT NOT NULL,
    "recipient" TEXT NOT NULL,
    "claimId" TEXT,
    "caseId" TEXT,
    "comments" TEXT,
    "status" TEXT NOT NULL DEFAULT 'DRAFT',
    "authorType" TEXT NOT NULL DEFAULT 'Individual',
    "autoSplit" BOOLEAN NOT NULL DEFAULT false,
    "category" TEXT NOT NULL DEFAULT 'DEFAULT',
    "sendInX12" BOOLEAN NOT NULL DEFAULT false,
    "threshold" INTEGER NOT NULL DEFAULT 100,
    "fhirAcknowledgment" TEXT,
    "transactionId" TEXT,
    "responseMessage" TEXT,
    "errorDescription" TEXT,
    "fhirSubmissionId" TEXT,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "submittedAt" DATETIME,
    "creatorId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "customerId" TEXT NOT NULL,
    CONSTRAINT "Submission_creatorId_fkey" FOREIGN KEY ("creatorId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Submission_providerId_fkey" FOREIGN KEY ("providerId") REFERENCES "Provider" ("id") ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT "Submission_customerId_fkey" FOREIGN KEY ("customerId") REFERENCES "Customer" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "SubmissionDocument" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "title" TEXT,
    "fileName" TEXT NOT NULL,
    "originalFileName" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "mimeType" TEXT NOT NULL,
    "objectKey" TEXT NOT NULL,
    "language" TEXT NOT NULL DEFAULT 'English',
    "documentType" TEXT NOT NULL DEFAULT 'PDF',
    "attachmentControlNumber" TEXT,
    "comments" TEXT,
    "fhirResourceId" TEXT,
    "uploadStatus" TEXT NOT NULL DEFAULT 'PENDING',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    "submissionId" TEXT NOT NULL,
    "uploaderId" TEXT NOT NULL,
    CONSTRAINT "SubmissionDocument_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "Submission" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "SubmissionDocument_uploaderId_fkey" FOREIGN KEY ("uploaderId") REFERENCES "User" ("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_PermissionToRole" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_PermissionToRole_A_fkey" FOREIGN KEY ("A") REFERENCES "Permission" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_PermissionToRole_B_fkey" FOREIGN KEY ("B") REFERENCES "Role" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_RoleToUser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_RoleToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Role" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_RoleToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_username_key" ON "User"("username");

-- CreateIndex
CREATE INDEX "User_customerId_idx" ON "User"("customerId");

-- CreateIndex
CREATE INDEX "User_providerGroupId_idx" ON "User"("providerGroupId");

-- CreateIndex
CREATE UNIQUE INDEX "UserImage_userId_key" ON "UserImage"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Password_userId_key" ON "Password"("userId");

-- CreateIndex
CREATE INDEX "Session_userId_idx" ON "Session"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Permission_action_entity_access_key" ON "Permission"("action", "entity", "access");

-- CreateIndex
CREATE UNIQUE INDEX "Role_name_key" ON "Role"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Verification_target_type_key" ON "Verification"("target", "type");

-- CreateIndex
CREATE UNIQUE INDEX "Connection_providerName_providerId_key" ON "Connection"("providerName", "providerId");

-- CreateIndex
CREATE INDEX "Passkey_userId_idx" ON "Passkey"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Customer_baaNumber_key" ON "Customer"("baaNumber");

-- CreateIndex
CREATE INDEX "Customer_name_idx" ON "Customer"("name");

-- CreateIndex
CREATE INDEX "ProviderGroup_customerId_idx" ON "ProviderGroup"("customerId");

-- CreateIndex
CREATE UNIQUE INDEX "ProviderGroup_customerId_name_key" ON "ProviderGroup"("customerId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "Provider_npi_key" ON "Provider"("npi");

-- CreateIndex
CREATE INDEX "Provider_customerId_idx" ON "Provider"("customerId");

-- CreateIndex
CREATE INDEX "Provider_providerGroupId_idx" ON "Provider"("providerGroupId");

-- CreateIndex
CREATE INDEX "Provider_npi_idx" ON "Provider"("npi");

-- CreateIndex
CREATE INDEX "UserNpi_userId_idx" ON "UserNpi"("userId");

-- CreateIndex
CREATE INDEX "UserNpi_providerId_idx" ON "UserNpi"("providerId");

-- CreateIndex
CREATE UNIQUE INDEX "UserNpi_userId_providerId_key" ON "UserNpi"("userId", "providerId");

-- CreateIndex
CREATE INDEX "Submission_creatorId_idx" ON "Submission"("creatorId");

-- CreateIndex
CREATE INDEX "Submission_providerId_idx" ON "Submission"("providerId");

-- CreateIndex
CREATE INDEX "Submission_customerId_idx" ON "Submission"("customerId");

-- CreateIndex
CREATE INDEX "Submission_status_idx" ON "Submission"("status");

-- CreateIndex
CREATE INDEX "Submission_purposeOfSubmission_idx" ON "Submission"("purposeOfSubmission");

-- CreateIndex
CREATE INDEX "SubmissionDocument_submissionId_idx" ON "SubmissionDocument"("submissionId");

-- CreateIndex
CREATE INDEX "SubmissionDocument_uploaderId_idx" ON "SubmissionDocument"("uploaderId");

-- CreateIndex
CREATE UNIQUE INDEX "_PermissionToRole_AB_unique" ON "_PermissionToRole"("A", "B");

-- CreateIndex
CREATE INDEX "_PermissionToRole_B_index" ON "_PermissionToRole"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_RoleToUser_AB_unique" ON "_RoleToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_RoleToUser_B_index" ON "_RoleToUser"("B");

--------------------------------- Manual Seeding --------------------------
-- Hey there, Kent here! This is how you can reliably seed your database with
-- some data. You edit the migration.sql file and that will handle it for you.

-- The user Roles and Permissions are seeded here.
-- If you'd like to customise roles and permissions, you can edit and add the code below to your `prisma/seed.ts` file.
-- Seed your development database with `npx prisma db seed`
-- Create a sql dump of your database with `sqlite3 prisma/data.db .dump > seed.sql`
-- Replace the SQL below with your new Roles & Permissions related SQL from `seed.sql`

-- console.time('🔑 Created permissions...')
-- const entities = ['user']
-- const actions = ['create', 'read', 'update', 'delete']
-- const accesses = ['own', 'any'] as const

-- let permissionsToCreate = []
-- for (const entity of entities) {
-- 	for (const action of actions) {
-- 		for (const access of accesses) {
-- 			permissionsToCreate.push({ entity, action, access })
-- 		}
-- 	}
-- }
-- await prisma.permission.createMany({ data: permissionsToCreate })
-- console.timeEnd('🔑 Created permissions...')

-- console.time('👑 Created roles...')
-- await prisma.role.create({
-- 	data: {
-- 		name: 'admin',
-- 		permissions: {
-- 			connect: await prisma.permission.findMany({
-- 				select: { id: true },
-- 				where: { access: 'any' },
-- 			}),
-- 		},
-- 	},
-- })
-- await prisma.role.create({
-- 	data: {
-- 		name: 'user',
-- 		permissions: {
-- 			connect: await prisma.permission.findMany({
-- 				select: { id: true },
-- 				where: { access: 'own' },
-- 			}),
-- 		},
-- 	},
-- })
-- console.timeEnd('👑 Created roles...')

INSERT INTO User VALUES('cmekez1g100041j0tet8d45cl','admin@interex.com','system_admin','Interex System Administrator',1,1755721035793,1755721035793,NULL,NULL);
INSERT INTO Password VALUES('$2b$10$id.uzRQivRtAziG/i/U7RehKFoCcLhFyWA7XHdJwkUtiNclwXhqNu','cmekez1g100041j0tet8d45cl');
INSERT INTO Role VALUES('cmekez1dc00001j0toahpwlj7','system-admin','System Administrator with capability to add new customers and manage the entire platform',1,1755721035696,1755721035696);
INSERT INTO Role VALUES('cmekez1dk00011j0tweqeiv4v','customer-admin','Customer Administrator with full access to customer organization data and users',1,1755721035705,1755721035705);
INSERT INTO Role VALUES('cmekez1dn00021j0tzpjg7s25','provider-group-admin','Provider Group Administrator with access to their specific provider group and submissions',1,1755721035708,1755721035708);
INSERT INTO Role VALUES('cmekez1dp00031j0ttustmsce','basic-user','Basic user with access to assigned NPIs and submission capabilities only',1,1755721035709,1755721035709);
INSERT INTO _RoleToUser VALUES('cmekez1dc00001j0toahpwlj7','cmekez1g100041j0tet8d45cl');