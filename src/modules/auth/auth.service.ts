import { BadRequestException, Injectable } from '@nestjs/common';
import { JwtPayload, SessionUser } from '@/modules/auth/types';
import { JwtTokenService } from '@/common/token/jwt-token.service';
import { CryptoService } from '@/common/crypto/crypto.service';
import { UserService } from '../user/user.service';
import { ValidatePasswordResetDto } from './dtos/validate-reset-password.dto';
import { PasswordService } from './password.service';
import { ChangePasswordDTO } from './dtos/change-password.dto';

@Injectable()
export class AuthService {
  constructor(
    private userService: UserService,
    private jwtTokenService: JwtTokenService,
    private cryptoService: CryptoService,
    private passwordService: PasswordService,
  ) {}

  validateApiKey(apiKey: string) {
    const apiKeys: string[] = ['api-key-1', 'api-key-2'];
    return apiKeys.find((key) => apiKey === key);
  }

  async validateUser(identifier: string,inputtedPassword: string) {
    let user = await this.userService.findUserByEmail(identifier);

  if (!user) {
    user = await this.userService.findUserByPhoneNumber(identifier);
  }

  if (!user) return null;
  

    const isMatch = await this.cryptoService.comparePassword(
      inputtedPassword,
      user.password,
    );

    if (!isMatch) return null;

    const { password, ...result } = user;
    return result;
  }

  async login(user: any) {
    const payload: JwtPayload = {
      phoneNumber: user.phoneNumber,
      sub: user.id,
      email: user.email,
      role: user.role,
    };
    const tokens = await this.jwtTokenService.generateToken(payload);
    return {
      ...tokens,
      profile: payload,
    };
  }

  async logout(token: string) {
    return this.jwtTokenService.blacklist(token);
  }

  async validatePasswordResetToken(data: ValidatePasswordResetDto) {
    const isTokenValid = await this.passwordService.isResetTokenValid(
      data.resetToken,
    );

    if (!isTokenValid) {
      throw new BadRequestException({
        status: 'error',
        message: 'Reset token is invalid.',
      });
    }

    return { status: 'success', message: 'Reset token is valid.' };
  }

  async changePassword(data: ChangePasswordDTO, user: SessionUser) {
    const passwordValid = await this.validateUser(user.email, data.oldPassword);

    if (!passwordValid) {
      throw new BadRequestException({
        status: 'error',
        message: 'Invalid Password',
      });
    }

    await this.passwordService.changePassword(user.userId, data.newPassword);

    return {
      status: 'success',
      message: 'Password changed successfully',
    };
  }
}
