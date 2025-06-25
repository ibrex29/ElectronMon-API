import {
  ConflictException,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { User } from '@prisma/client';
import { PrismaService } from '@/common/prisma/prisma.service';
import { UserNotFoundException } from '@/modules/user/exceptions/UserNotFound.exception';
import { CreateUserDto } from './dtos/sign-up.dto';
import { SessionUser } from '../auth/types';
import { UserType } from './types';

@Injectable()
export class UserService {
  constructor(
    private prisma: PrismaService
  ) {}
  async createUser(dto: CreateUserDto) {
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });
  
    if (existingUser) {
      throw new ConflictException(`User with email: ${dto.email} already exists.`);
    }
  
    const createdUser = await this.prisma.user.create({
      data: {
        phoneNumber: dto.phoneNumber,
        email: dto.email,
        password: dto.password,
        firstName: dto.firstName,
        lastName: dto.lastName,
        otherNames: dto.otherNames,
        role: dto.role || UserType.USER,
        isActive: true,
      },
    });
  
    delete createdUser.password;
    return createdUser;
  }
  
  async findUserByEmail(email: string) {
    return this.prisma.user.findFirst({
      where: {
        email,
      },
      select: {
        id: true,
        phoneNumber: true,
        email: true,
        password: true,
        isActive: true,
        role: true,
        firstName:true,
        lastName:true
      },
    });
  }

  async findUserByPhoneNumber(phoneNumber: string) {
    return this.prisma.user.findUnique({ where: { phoneNumber } });
  }

  async findUserById(id: string): Promise<User | null> {
    return this.prisma.user.findUnique({
      where: {
        id,
      },
    });
  }

  async deleteUser(userId: string): Promise<User> {
    await this.validateUserExists(userId);

    return this.prisma.user.delete({
      where: {
        id: userId,
      },
    });
  }

  async validateUserExists(userId: string): Promise<void> {
    const user = await this.prisma.user.findUnique({ where: { id: userId } });
    if (!user) {
      throw new UserNotFoundException();
    }
  }

  async validateUserEmailExists(email: string): Promise<void> {
    const user = await this.prisma.user.findUnique({ where: { email: email } });
    if (!user) {
      throw new UserNotFoundException();
    }
  }

  async activateUser(userId: string): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    await this.prisma.user.update({
      where: { id: userId },
      data: {
        isActive: true,
      },
    });
  }

  async deactivateUser(userId: string): Promise<void> {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    await this.prisma.user.update({
      where: { id: userId },
      data: {
        isActive: false,
      },
    });
  }
}
