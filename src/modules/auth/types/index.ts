export { SessionUser } from '@/common/types/sessioon-user.type';
export type JwtPayload = {
  sub: string;
  phoneNumber: string;
  email?: string;
  role: string;
};
