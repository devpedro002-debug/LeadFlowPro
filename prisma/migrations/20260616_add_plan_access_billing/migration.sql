-- CreateEnum
CREATE TYPE "UserPlan" AS ENUM ('STARTER', 'PROFISSIONAL', 'ENTERPRISE');

-- CreateEnum
CREATE TYPE "AccessStatus" AS ENUM ('ATIVO', 'PAUSADO', 'SUSPENSO', 'CANCELADO', 'AGUARDANDO_PAGAMENTO', 'EM_TESTE');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PAGO', 'PENDENTE', 'VENCIDO', 'EM_TESTE', 'ISENTO', 'CANCELADO');

-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('USER', 'SUPER_ADMIN');

-- DropIndex
DROP INDEX "idx_leads_company_trgm";

-- DropIndex
DROP INDEX "idx_leads_email_trgm";

-- DropIndex
DROP INDEX "idx_leads_full_name_trgm";

-- DropIndex
DROP INDEX "idx_leads_job_title_trgm";

-- DropIndex
DROP INDEX "idx_leads_phone_trgm";

-- AlterTable
ALTER TABLE "cadence_stages" ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "updated_at" DROP DEFAULT;

-- AlterTable
ALTER TABLE "cadences" ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "updated_at" DROP DEFAULT;

-- AlterTable
ALTER TABLE "lead_cadence_events" ALTER COLUMN "id" DROP DEFAULT;

-- AlterTable
ALTER TABLE "lead_cadence_progress" ALTER COLUMN "id" DROP DEFAULT;

-- AlterTable
ALTER TABLE "lead_scheduled_actions" ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "updated_at" DROP DEFAULT;

-- AlterTable
ALTER TABLE "notifications" ALTER COLUMN "id" DROP DEFAULT,
ALTER COLUMN "updated_at" DROP DEFAULT;

-- AlterTable
ALTER TABLE "profiles" ADD COLUMN     "access_status" "AccessStatus" NOT NULL DEFAULT 'EM_TESTE',
ADD COLUMN     "expires_at" TIMESTAMP(3),
ADD COLUMN     "internal_notes" TEXT,
ADD COLUMN     "last_payment_at" TIMESTAMP(3),
ADD COLUMN     "monthly_amount" DECIMAL(10,2),
ADD COLUMN     "next_billing_at" TIMESTAMP(3),
ADD COLUMN     "payment_method" TEXT,
ADD COLUMN     "payment_status" "PaymentStatus" NOT NULL DEFAULT 'EM_TESTE',
ADD COLUMN     "plan" "UserPlan" NOT NULL DEFAULT 'STARTER',
ADD COLUMN     "role" "UserRole" NOT NULL DEFAULT 'USER',
ADD COLUMN     "suspension_reason" TEXT;

-- DropEnum
DROP TYPE "LeadStatusExt";

-- CreateTable
CREATE TABLE "billing_records" (
    "id" TEXT NOT NULL,
    "profile_id" TEXT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "payment_status" "PaymentStatus" NOT NULL,
    "payment_method" TEXT,
    "reference_month" TEXT,
    "paid_at" TIMESTAMP(3),
    "due_at" TIMESTAMP(3),
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "billing_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admin_audit_logs" (
    "id" TEXT NOT NULL,
    "admin_email" TEXT NOT NULL,
    "target_profile_id" TEXT,
    "target_email" TEXT,
    "action" TEXT NOT NULL,
    "previous_data" JSONB,
    "new_data" JSONB,
    "reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "billing_records_profile_id_idx" ON "billing_records"("profile_id");

-- CreateIndex
CREATE INDEX "billing_records_payment_status_idx" ON "billing_records"("payment_status");

-- CreateIndex
CREATE INDEX "idx_billing_profile_created" ON "billing_records"("profile_id", "created_at" DESC);

-- CreateIndex
CREATE INDEX "admin_audit_logs_admin_email_idx" ON "admin_audit_logs"("admin_email");

-- CreateIndex
CREATE INDEX "admin_audit_logs_target_profile_id_idx" ON "admin_audit_logs"("target_profile_id");

-- CreateIndex
CREATE INDEX "admin_audit_logs_action_idx" ON "admin_audit_logs"("action");

-- CreateIndex
CREATE INDEX "admin_audit_logs_created_at_idx" ON "admin_audit_logs"("created_at");

-- CreateIndex
CREATE INDEX "cadence_stages_cadence_id_idx" ON "cadence_stages"("cadence_id");

-- CreateIndex
CREATE INDEX "cadence_stages_template_id_idx" ON "cadence_stages"("template_id");

-- CreateIndex
CREATE INDEX "idx_lead_cadence_stage_queue" ON "lead_cadence_progress"("profile_id", "status", "current_stage_order", "next_scheduled_at", "version");

-- CreateIndex
CREATE INDEX "idx_lead_cadence_cadence_status" ON "lead_cadence_progress"("cadence_id", "status");

-- AddForeignKey
ALTER TABLE "billing_records" ADD CONSTRAINT "billing_records_profile_id_fkey" FOREIGN KEY ("profile_id") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
