create table EXT_Foo (
	uuid_ VARCHAR(75) null,
	fooId BIGINT not null primary key,
	groupId BIGINT,
	companyId BIGINT,
	userId BIGINT,
	userName VARCHAR(75) null,
	createDate DATE null,
	modifiedDate DATE null,
	field1 VARCHAR(75) null,
	field2 BOOLEAN,
	field3 INTEGER,
	field4 DATE null,
	field5 VARCHAR(75) null
);
