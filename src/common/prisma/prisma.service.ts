import { Prisma, PrismaClient } from '@prisma/client';
import { Injectable, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { CryptoService } from '../crypto/crypto.service';
import { FetchDTO, PaginationResultDTO } from '../dto';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
  constructor(
    private configService: ConfigService,
    private cryptoService: CryptoService,
  ) {
    super();
  }

  async onModuleInit() {
    await this.$connect();
    this.$use(async (params, next) => {
      // create operation
      if (params.action === 'create' && params.model === 'User') {
        // hash user password
        const user = params.args.data;
        user.password = await this.cryptoService.hashPassword(user.password);
        params.args.data = user;
      }
      return next(params);
    });
  }

  async disconnect() {
    // Ensure that the PrismaClient disconnects from the database when the application is shut down.
    await this.$disconnect();
  }

  async paginate<T>(
    modelName: Prisma.ModelName,
    {
      query,
      where,
      include = {},
      orderBy = undefined,
    }: {
      query: FetchDTO & { sortField?: string };
      where: object;
      include?: object;
      orderBy?: object;
    },
  ): Promise<PaginationResultDTO<T>> {
    const { limit, page } = query;

    const findOption: {
      skip: number;
      take: number;
      where: object;
      include: object;
      orderBy?: object;
    } = {
      skip: (page - 1) * limit,
      take: limit,
      where,
      include,
    };
    if (orderBy) findOption.orderBy = orderBy;

    const [count, rows] = await Promise.all([
      this[modelName].count({ where }),
      this[modelName].findMany(findOption),
    ]);

    return new PaginationResultDTO(rows, count, query);
  }
}
