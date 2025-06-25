import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const password = 'StrongPassword123!';
  const hashedPassword = await bcrypt.hash(password, 10);

  await prisma.user.upsert({
    where: { email: 'admin11@example.com' },
    update: {},
    create: {
      email: 'admin11@example.com',
      isActive: true,
      password: hashedPassword,
      phoneNumber:"+2348012345678",
      firstName: 'Admin',
      lastName: 'User',
      country: 'Nigeria',
    },
  });

  const states = [
    { name: "Abia", code: "AB" }, { name: "Adamawa", code: "AD" }, { name: "Akwa Ibom", code: "AK" },
    { name: "Anambra", code: "AN" }, { name: "Bauchi", code: "BA" }, { name: "Bayelsa", code: "BY" },
    { name: "Benue", code: "BE" }, { name: "Borno", code: "BO" }, { name: "Cross River", code: "CR" },
    { name: "Delta", code: "DE" }, { name: "Ebonyi", code: "EB" }, { name: "Edo", code: "ED" },
    { name: "Ekiti", code: "EK" }, { name: "Enugu", code: "EN" }, { name: "Gombe", code: "GO" },
    { name: "Imo", code: "IM" }, { name: "Jigawa", code: "JI" }, { name: "Kaduna", code: "KD" },
    { name: "Kano", code: "KN" }, { name: "Katsina", code: "KT" }, { name: "Kebbi", code: "KB" },
    { name: "Kogi", code: "KO" }, { name: "Kwara", code: "KW" }, { name: "Lagos", code: "LA" },
    { name: "Nasarawa", code: "NA" }, { name :"Niger", code: "NI" }, { name: "Ogun", code: "OG" },
    { name: "Ondo", code: "ON" }, { name: "Osun", code: "OS" }, { name: "Oyo", code: "OY" },
    { name: "Plateau", code: "PL" }, { name: "Rivers", code: "RI" }, { name: "Sokoto", code: "SO" },
    { name: "Taraba", code: "TA" }, { name: "Yobe", code: "YO" }, { name: "Zamfara", code: "ZA" },
    { name: "FCT", code: "FC" },
  ];

  for (const state of states) {
    await prisma.state.upsert({
      where: { code: state.code },
      update: {},
      create: state,
    });
  }

  console.log('Seeding completed');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
