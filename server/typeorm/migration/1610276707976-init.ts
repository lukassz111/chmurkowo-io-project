import {MigrationInterface, QueryRunner} from "typeorm";

export class init1610276707976 implements MigrationInterface {
    name = 'init1610276707976'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query("CREATE TABLE `user` (`id` int NOT NULL AUTO_INCREMENT, `googleId` varchar(255) NOT NULL, `displayName` varchar(255) NOT NULL, `score` int NOT NULL, `premium` tinyint NOT NULL, `email` varchar(255) NOT NULL, `photosLeft` int NOT NULL, `lastPhotoTimestamp` int NOT NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB");
        await queryRunner.query("CREATE TABLE `pin` (`id` int NOT NULL AUTO_INCREMENT, `latitude` int NOT NULL, `longitude` int NOT NULL, `photo_filename` varchar(255) NOT NULL, `userId` int NULL, PRIMARY KEY (`id`)) ENGINE=InnoDB");
        await queryRunner.query("ALTER TABLE `pin` ADD CONSTRAINT `FK_cef7b4e95a2ba540dfc8490e16a` FOREIGN KEY (`userId`) REFERENCES `user`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION");
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query("ALTER TABLE `pin` DROP FOREIGN KEY `FK_cef7b4e95a2ba540dfc8490e16a`");
        await queryRunner.query("DROP TABLE `pin`");
        await queryRunner.query("DROP TABLE `user`");
    }

}
