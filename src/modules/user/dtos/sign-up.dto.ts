// signup.dto.ts
import {
  IsEmail,
  IsNotEmpty,
  IsOptional,
  IsString,
  IsBoolean,
  IsDateString,
  IsEnum,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { UserType } from '../types';

export class CreateUserDto {
  @ApiProperty({ required: false, description: 'User phone number' })
  @IsOptional()
  phoneNumber?: string;

  @ApiProperty({ description: 'User email address', uniqueItems: true })
  @IsEmail()
  email: string;

  @ApiProperty({ description: 'User password' })
  @IsString()
  @IsNotEmpty()
  password: string;

  @ApiProperty({ description: 'User first name' })
  @IsString()
  @IsNotEmpty()
  firstName: string;

  @ApiProperty({ description: 'User last name' })
  @IsString()
  @IsNotEmpty()
  lastName: string;

  @ApiProperty({ required: false, description: 'User other names' })
  @IsOptional()
  @IsString()
  otherNames?: string;

  @ApiProperty({ description: 'User gender' })
  @IsString()
  @IsNotEmpty()
  gender: string;

  @ApiProperty({ description: 'User date of birth' })
  @IsDateString()
  dob: Date;

  @ApiProperty({ description: 'User address' })
  @IsString()
  @IsNotEmpty()
  address: string;

  @ApiProperty({ description: 'User state' })
  @IsString()
  @IsNotEmpty()
  state: string;

  @ApiProperty({
    required: false,
    description: 'User country',
    default: 'nigeria',
  })
  @IsString()
  @IsOptional()
  country?: string = 'nigeria';

  @ApiProperty({ required: false, description: 'User role', default: 'user' })
  @IsEnum(UserType)
  @IsOptional()
  role?: UserType = UserType.USER;

}