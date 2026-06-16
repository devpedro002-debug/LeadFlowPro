-- CreateEnum
CREATE TYPE "CadenceStatus" AS ENUM ('ACTIVE', 'PAUSED', 'FINISHED', 'CANCELED', 'REPLIED');

-- CreateEnum
CREATE TYPE "LeadStatusExt" AS ENUM ('PAUSADO');

-- Adicionar valor PAUSADO ao enum LeadStatus se não existir
DO $$ BEGIN
  ALTER TYPE "LeadStatus" ADD VALUE IF NOT EXISTS 'PAUSADO';
EXCEPTION WHEN others THEN NULL; END $$;

-- CreateTable: CadenceEngine (cadences)
CREATE TABLE IF NOT EXISTS "cadences" (
    "id"          TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "profile_id"  TEXT,
    "name"        TEXT NOT NULL,
    "description" TEXT,
    "is_active"   BOOLEAN NOT NULL DEFAULT true,
    "created_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cadences_pkey" PRIMARY KEY ("id")
);

-- CreateTable: CadenceStage (cadence_stages)
CREATE TABLE IF NOT EXISTS "cadence_stages" (
    "id"          TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "cadence_id"  TEXT NOT NULL,
    "order"       INTEGER NOT NULL,
    "channel"     "TemplateChannel" NOT NULL,
    "delay_days"  INTEGER NOT NULL,
    "template_id" TEXT,
    "created_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cadence_stages_pkey" PRIMARY KEY ("id")
);

-- CreateTable: LeadCadenceProgress (lead_cadence_progress)
CREATE TABLE IF NOT EXISTS "lead_cadence_progress" (
    "id"                  TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "profile_id"          TEXT NOT NULL,
    "lead_id"             TEXT NOT NULL,
    "cadence_id"          TEXT NOT NULL,
    "current_stage_order" INTEGER NOT NULL DEFAULT 1,
    "next_stage_order"    INTEGER,
    "status"              "CadenceStatus" NOT NULL DEFAULT 'ACTIVE',
    "paused_at"           TIMESTAMP(3),
    "finished_at"         TIMESTAMP(3),
    "exit_reason"         TEXT,
    "next_scheduled_at"   TIMESTAMP(3) NOT NULL,
    "last_action_at"      TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "version"             INTEGER NOT NULL DEFAULT 0,
    "locked_at"           TIMESTAMP(3),
    "locked_by"           TEXT,

    CONSTRAINT "lead_cadence_progress_pkey" PRIMARY KEY ("id")
);

-- CreateTable: LeadCadenceEvent (lead_cadence_events)
CREATE TABLE IF NOT EXISTS "lead_cadence_events" (
    "id"                TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "lead_cadence_id"   TEXT NOT NULL,
    "lead_id"           TEXT NOT NULL,
    "action"            TEXT NOT NULL,
    "from_stage"        INTEGER,
    "to_stage"          INTEGER,
    "operator_id"       TEXT,
    "notes"             TEXT,
    "created_at"        TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "lead_cadence_events_pkey" PRIMARY KEY ("id")
);

-- CreateTable: Notification (notifications)
CREATE TABLE IF NOT EXISTS "notifications" (
    "id"          TEXT NOT NULL DEFAULT gen_random_uuid()::text,
    "profile_id"  TEXT NOT NULL,
    "lead_id"     TEXT,
    "title"       TEXT NOT NULL,
    "message"     TEXT NOT NULL,
    "is_read"     BOOLEAN NOT NULL DEFAULT false,
    "type"        TEXT NOT NULL DEFAULT 'CADENCE_OVERDUE',
    "metadata"    JSONB,
    "created_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "notifications_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX IF NOT EXISTS "cadences_profile_id_idx" ON "cadences"("profile_id");

CREATE UNIQUE INDEX IF NOT EXISTS "lead_cadence_progress_lead_id_key" ON "lead_cadence_progress"("lead_id");
CREATE INDEX IF NOT EXISTS "lead_cadence_progress_profile_id_status_next_scheduled_at_idx" ON "lead_cadence_progress"("profile_id", "status", "next_scheduled_at");
CREATE INDEX IF NOT EXISTS "lead_cadence_progress_lead_id_idx" ON "lead_cadence_progress"("lead_id");

CREATE INDEX IF NOT EXISTS "lead_cadence_events_lead_cadence_id_idx" ON "lead_cadence_events"("lead_cadence_id");
CREATE INDEX IF NOT EXISTS "lead_cadence_events_lead_id_idx" ON "lead_cadence_events"("lead_id");

CREATE INDEX IF NOT EXISTS "notifications_profile_id_idx" ON "notifications"("profile_id");
CREATE INDEX IF NOT EXISTS "notifications_is_read_idx" ON "notifications"("is_read");

-- AddForeignKey
ALTER TABLE "cadences" ADD CONSTRAINT "cadences_profile_id_fkey"
    FOREIGN KEY ("profile_id") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cadence_stages" ADD CONSTRAINT "cadence_stages_cadence_id_fkey"
    FOREIGN KEY ("cadence_id") REFERENCES "cadences"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cadence_stages" ADD CONSTRAINT "cadence_stages_template_id_fkey"
    FOREIGN KEY ("template_id") REFERENCES "templates"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "lead_cadence_progress" ADD CONSTRAINT "lead_cadence_progress_lead_id_fkey"
    FOREIGN KEY ("lead_id") REFERENCES "leads"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "lead_cadence_progress" ADD CONSTRAINT "lead_cadence_progress_cadence_id_fkey"
    FOREIGN KEY ("cadence_id") REFERENCES "cadences"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "lead_cadence_events" ADD CONSTRAINT "lead_cadence_events_lead_cadence_id_fkey"
    FOREIGN KEY ("lead_cadence_id") REFERENCES "lead_cadence_progress"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "notifications" ADD CONSTRAINT "notifications_profile_id_fkey"
    FOREIGN KEY ("profile_id") REFERENCES "profiles"("id") ON DELETE CASCADE ON UPDATE CASCADE;
