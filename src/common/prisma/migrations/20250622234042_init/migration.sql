-- CreateTable
CREATE TABLE "user" (
    "id" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "deletedAt" TIMESTAMP(3),
    "phoneNumber" TEXT,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "authStrategy" TEXT,
    "role" TEXT NOT NULL DEFAULT 'user',
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "otherNames" TEXT,
    "country" TEXT NOT NULL DEFAULT 'nigeria',
    "createdByUserId" TEXT,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "State" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,

    CONSTRAINT "State_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "LocalGovernment" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "stateId" TEXT NOT NULL,

    CONSTRAINT "LocalGovernment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Ward" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "lgaId" TEXT NOT NULL,

    CONSTRAINT "Ward_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PollingUnit" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "address" TEXT,
    "latitude" DOUBLE PRECISION,
    "longitude" DOUBLE PRECISION,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "wardId" TEXT NOT NULL,

    CONSTRAINT "PollingUnit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Election" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'upcoming',

    CONSTRAINT "Election_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Result" (
    "id" TEXT NOT NULL,
    "pollingUnitId" TEXT NOT NULL,
    "electionId" TEXT NOT NULL,
    "partyCode" TEXT NOT NULL,
    "votes" INTEGER NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Result_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IncidentReport" (
    "id" TEXT NOT NULL,
    "pollingUnitId" TEXT NOT NULL,
    "reporterName" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "IncidentReport_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PasswordResetToken" (
    "email" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expiresAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PasswordResetToken_pkey" PRIMARY KEY ("token")
);

-- CreateTable
CREATE TABLE "BlacklistedToken" (
    "token" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "BlacklistedToken_pkey" PRIMARY KEY ("token")
);

-- CreateIndex
CREATE UNIQUE INDEX "user_phoneNumber_key" ON "user"("phoneNumber");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "State_code_key" ON "State"("code");

-- CreateIndex
CREATE UNIQUE INDEX "PollingUnit_code_key" ON "PollingUnit"("code");

-- AddForeignKey
ALTER TABLE "LocalGovernment" ADD CONSTRAINT "LocalGovernment_stateId_fkey" FOREIGN KEY ("stateId") REFERENCES "State"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ward" ADD CONSTRAINT "Ward_lgaId_fkey" FOREIGN KEY ("lgaId") REFERENCES "LocalGovernment"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PollingUnit" ADD CONSTRAINT "PollingUnit_wardId_fkey" FOREIGN KEY ("wardId") REFERENCES "Ward"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Result" ADD CONSTRAINT "Result_pollingUnitId_fkey" FOREIGN KEY ("pollingUnitId") REFERENCES "PollingUnit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Result" ADD CONSTRAINT "Result_electionId_fkey" FOREIGN KEY ("electionId") REFERENCES "Election"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncidentReport" ADD CONSTRAINT "IncidentReport_pollingUnitId_fkey" FOREIGN KEY ("pollingUnitId") REFERENCES "PollingUnit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
