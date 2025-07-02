/*
  Warnings:

  - You are about to drop the column `address` on the `PollingUnit` table. All the data in the column will be lost.
  - You are about to drop the column `isActive` on the `PollingUnit` table. All the data in the column will be lost.
  - You are about to drop the column `latitude` on the `PollingUnit` table. All the data in the column will be lost.
  - You are about to drop the column `longitude` on the `PollingUnit` table. All the data in the column will be lost.
  - You are about to drop the column `electionId` on the `Result` table. All the data in the column will be lost.
  - You are about to drop the column `partyCode` on the `Result` table. All the data in the column will be lost.
  - You are about to drop the column `timestamp` on the `Result` table. All the data in the column will be lost.
  - You are about to drop the column `votes` on the `Result` table. All the data in the column will be lost.
  - You are about to drop the column `lgaId` on the `Ward` table. All the data in the column will be lost.
  - You are about to drop the `Election` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `IncidentReport` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[name,stateId]` on the table `LocalGovernment` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[headId]` on the table `PollingUnit` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[name]` on the table `State` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[headId]` on the table `Ward` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `headId` to the `PollingUnit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `status` to the `PollingUnit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `PollingUnit` table without a default value. This is not possible if the table is not empty.
  - Added the required column `imageUrl` to the `Result` table without a default value. This is not possible if the table is not empty.
  - Added the required column `status` to the `Result` table without a default value. This is not possible if the table is not empty.
  - Added the required column `uploadedBy` to the `Result` table without a default value. This is not possible if the table is not empty.
  - Added the required column `constituencyId` to the `Ward` table without a default value. This is not possible if the table is not empty.
  - Added the required column `headId` to the `Ward` table without a default value. This is not possible if the table is not empty.
  - Added the required column `updatedAt` to the `Ward` table without a default value. This is not possible if the table is not empty.
  - Changed the type of `role` on the `user` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "Role" AS ENUM ('USER', 'CONSTITUENCY_HEAD', 'WARD_HEAD', 'PU_HEAD');

-- DropForeignKey
ALTER TABLE "IncidentReport" DROP CONSTRAINT "IncidentReport_pollingUnitId_fkey";

-- DropForeignKey
ALTER TABLE "Result" DROP CONSTRAINT "Result_electionId_fkey";

-- DropForeignKey
ALTER TABLE "Ward" DROP CONSTRAINT "Ward_lgaId_fkey";

-- AlterTable
ALTER TABLE "PollingUnit" DROP COLUMN "address",
DROP COLUMN "isActive",
DROP COLUMN "latitude",
DROP COLUMN "longitude",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "headId" TEXT NOT NULL,
ADD COLUMN     "status" TEXT NOT NULL,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "Result" DROP COLUMN "electionId",
DROP COLUMN "partyCode",
DROP COLUMN "timestamp",
DROP COLUMN "votes",
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "imageUrl" TEXT NOT NULL,
ADD COLUMN     "notes" TEXT,
ADD COLUMN     "status" TEXT NOT NULL,
ADD COLUMN     "uploadedBy" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "Ward" DROP COLUMN "lgaId",
ADD COLUMN     "constituencyId" TEXT NOT NULL,
ADD COLUMN     "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "headId" TEXT NOT NULL,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "user" ADD COLUMN     "puUnitId" TEXT,
DROP COLUMN "role",
ADD COLUMN     "role" "Role" NOT NULL;

-- DropTable
DROP TABLE "Election";

-- DropTable
DROP TABLE "IncidentReport";

-- CreateTable
CREATE TABLE "Constituency" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "headId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Constituency_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IssueReport" (
    "id" TEXT NOT NULL,
    "pollingUnitId" TEXT NOT NULL,
    "reportedBy" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "imageUrl" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "IssueReport_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_LGAWards" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_LocalGovernmentToState" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_PollingUnitToResult" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_ResultToUser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_IssueReportToPollingUnit" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateTable
CREATE TABLE "_IssueReportToUser" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "Constituency_headId_key" ON "Constituency"("headId");

-- CreateIndex
CREATE UNIQUE INDEX "_LGAWards_AB_unique" ON "_LGAWards"("A", "B");

-- CreateIndex
CREATE INDEX "_LGAWards_B_index" ON "_LGAWards"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_LocalGovernmentToState_AB_unique" ON "_LocalGovernmentToState"("A", "B");

-- CreateIndex
CREATE INDEX "_LocalGovernmentToState_B_index" ON "_LocalGovernmentToState"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_PollingUnitToResult_AB_unique" ON "_PollingUnitToResult"("A", "B");

-- CreateIndex
CREATE INDEX "_PollingUnitToResult_B_index" ON "_PollingUnitToResult"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_ResultToUser_AB_unique" ON "_ResultToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_ResultToUser_B_index" ON "_ResultToUser"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_IssueReportToPollingUnit_AB_unique" ON "_IssueReportToPollingUnit"("A", "B");

-- CreateIndex
CREATE INDEX "_IssueReportToPollingUnit_B_index" ON "_IssueReportToPollingUnit"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_IssueReportToUser_AB_unique" ON "_IssueReportToUser"("A", "B");

-- CreateIndex
CREATE INDEX "_IssueReportToUser_B_index" ON "_IssueReportToUser"("B");

-- CreateIndex
CREATE UNIQUE INDEX "LocalGovernment_name_stateId_key" ON "LocalGovernment"("name", "stateId");

-- CreateIndex
CREATE UNIQUE INDEX "PollingUnit_headId_key" ON "PollingUnit"("headId");

-- CreateIndex
CREATE UNIQUE INDEX "State_name_key" ON "State"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Ward_headId_key" ON "Ward"("headId");

-- AddForeignKey
ALTER TABLE "Constituency" ADD CONSTRAINT "Constituency_headId_fkey" FOREIGN KEY ("headId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ward" ADD CONSTRAINT "Ward_constituencyId_fkey" FOREIGN KEY ("constituencyId") REFERENCES "Constituency"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Ward" ADD CONSTRAINT "Ward_headId_fkey" FOREIGN KEY ("headId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PollingUnit" ADD CONSTRAINT "PollingUnit_headId_fkey" FOREIGN KEY ("headId") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Result" ADD CONSTRAINT "Result_uploadedBy_fkey" FOREIGN KEY ("uploadedBy") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IssueReport" ADD CONSTRAINT "IssueReport_pollingUnitId_fkey" FOREIGN KEY ("pollingUnitId") REFERENCES "PollingUnit"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IssueReport" ADD CONSTRAINT "IssueReport_reportedBy_fkey" FOREIGN KEY ("reportedBy") REFERENCES "user"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LGAWards" ADD CONSTRAINT "_LGAWards_A_fkey" FOREIGN KEY ("A") REFERENCES "LocalGovernment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LGAWards" ADD CONSTRAINT "_LGAWards_B_fkey" FOREIGN KEY ("B") REFERENCES "Ward"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LocalGovernmentToState" ADD CONSTRAINT "_LocalGovernmentToState_A_fkey" FOREIGN KEY ("A") REFERENCES "LocalGovernment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_LocalGovernmentToState" ADD CONSTRAINT "_LocalGovernmentToState_B_fkey" FOREIGN KEY ("B") REFERENCES "State"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PollingUnitToResult" ADD CONSTRAINT "_PollingUnitToResult_A_fkey" FOREIGN KEY ("A") REFERENCES "PollingUnit"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_PollingUnitToResult" ADD CONSTRAINT "_PollingUnitToResult_B_fkey" FOREIGN KEY ("B") REFERENCES "Result"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ResultToUser" ADD CONSTRAINT "_ResultToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "Result"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_ResultToUser" ADD CONSTRAINT "_ResultToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_IssueReportToPollingUnit" ADD CONSTRAINT "_IssueReportToPollingUnit_A_fkey" FOREIGN KEY ("A") REFERENCES "IssueReport"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_IssueReportToPollingUnit" ADD CONSTRAINT "_IssueReportToPollingUnit_B_fkey" FOREIGN KEY ("B") REFERENCES "PollingUnit"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_IssueReportToUser" ADD CONSTRAINT "_IssueReportToUser_A_fkey" FOREIGN KEY ("A") REFERENCES "IssueReport"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_IssueReportToUser" ADD CONSTRAINT "_IssueReportToUser_B_fkey" FOREIGN KEY ("B") REFERENCES "user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
