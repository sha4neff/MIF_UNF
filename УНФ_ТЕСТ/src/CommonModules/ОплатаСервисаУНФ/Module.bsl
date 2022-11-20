////////////////////////////////////////////////////////////////////////////////
// Подсистема "Оплата сервиса УНФ" (сервер).
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

Функция ДанныеДокументов(АдресаФайловXML) Экспорт
	Возврат Документы.СчетНаОплату.РазобратьСчетаНаОплатуПокупателюXML(АдресаФайловXML);
КонецФункции


Функция СоздатьКонтрагента(ДанныеЗаполнения) Экспорт
	Возврат Справочники.Контрагенты.СоздатьКонтрагента(ДанныеЗаполнения);
КонецФункции

Функция СоздатьСчетНаОплатуПоставщика(ИННОрганизации, Контрагент, Товары, НомерСчета, ДатаСчета, СуммаВключаетНДС) Экспорт
	Организация = Справочники.Организации.НайтиПоРеквизиту("ИНН", ИННОрганизации);
	
	Если Не ЗначениеЗаполнено(Организация) Тогда
		Возврат Документы.СчетНаОплатуПоставщика.ПустаяСсылка();
	КонецЕсли;
	
	ДанныеЗаполнения = Новый Структура;
	ДанныеЗаполнения.Вставить("Организация", Организация);
	ДанныеЗаполнения.Вставить("Дата", ДатаСчета);
	ДанныеЗаполнения.Вставить("ДатаВходящегоДокумента", ДатаСчета);
	ДанныеЗаполнения.Вставить("НомерВходящегоДокумента", НомерСчета);
	ДанныеЗаполнения.Вставить("Контрагент", Контрагент);
	ДанныеЗаполнения.Вставить("БанковскийСчет", Контрагент.БанковскийСчетПоУмолчанию);
	ДанныеЗаполнения.Вставить("СуммаВключаетНДС", СуммаВключаетНДС);
	Если Не Контрагент.ВестиРасчетыПоДоговорам Тогда
		ДанныеЗаполнения.Вставить("Договор", Справочники.ДоговорыКонтрагентов.ДоговорПоУмолчанию(Контрагент));
	Иначе
		МенеджерСправочника = Справочники.ДоговорыКонтрагентов;
		СписокВидовДоговоров = МенеджерСправочника.ПолучитьСписокВидовДоговораДляДокумента(Документы.СчетНаОплатуПоставщика.ПустаяСсылка());
		ДоговорПоУмолчанию = МенеджерСправочника.ПолучитьДоговорПоУмолчаниюПоОрганизацииВидуДоговора(Контрагент, Организация, СписокВидовДоговоров);
		ДанныеЗаполнения.Вставить("Договор", ДоговорПоУмолчанию);
	КонецЕсли;
	ДанныеЗаполнения.Вставить("ВалютаДокумента", Контрагент.БанковскийСчетПоУмолчанию.ВалютаДенежныхСредств);
	
	НовыйСчет = Документы.СчетНаОплатуПоставщика.СоздатьДокумент();
	ЗаполнитьЗначенияСвойств(НовыйСчет, ДанныеЗаполнения);
	НовыйСчет.Заполнить(ДанныеЗаполнения);
	
	ПользовательскаяНастройкаОсновнойКассы = УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователи.АвторизованныйПользователь(), "ОсновнаяКасса");
	Если НЕ Организация.Пустая() И 
		(НЕ ЗначениеЗаполнено(ПользовательскаяНастройкаОсновнойКассы) ИЛИ ПользовательскаяНастройкаОсновнойКассы.ПометкаУдаления) Тогда
		
		ТекКассаПоУмолчанию = Организация.КассаПоУмолчанию;
		Если Не ТекКассаПоУмолчанию.Пустая() И ТекКассаПоУмолчанию.ПометкаУдаления Тогда
			ТекКассаПоУмолчанию = Справочники.Кассы.ПустаяСсылка();
		КонецЕсли;
	Иначе
		ТекКассаПоУмолчанию = ПользовательскаяНастройкаОсновнойКассы;
	КонецЕсли;
	НовыйСчет.Касса = ТекКассаПоУмолчанию;
	
	Для каждого Товар Из Товары Цикл
		НоваяСтрока = НовыйСчет.Запасы.Добавить();
		НоваяСтрока.Номенклатура = НайтиСоздатьУслугуПоНаименованию(Товар.Наименование, 
			Товар.СтавкаНДС);
		НоваяСтрока.ЕдиницаИзмерения = НоваяСтрока.Номенклатура.ЕдиницаИзмерения;
		НоваяСтрока.Количество = Товар.Количество;
		НоваяСтрока.Цена       = Товар.Цена;
		НоваяСтрока.Сумма      = Товар.Сумма;
		НоваяСтрока.СуммаНДС   = Товар.СуммаНДС;
		НоваяСтрока.СтавкаНДС  = Товар.СтавкаНДС;
		НоваяСтрока.Всего = НоваяСтрока.Сумма + НоваяСтрока.СуммаНДС;
	КонецЦикла;
	
	Если НовыйСчет.Запасы.Итог("СуммаНДС") > 0 Тогда
		НовыйСчет.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.ОблагаетсяНДС;
	Иначе
		НовыйСчет.НалогообложениеНДС = Перечисления.ТипыНалогообложенияНДС.НеОблагаетсяНДС;
	КонецЕсли;
		
	НовыйСчет.ДополнительныеСвойства.Вставить("НеПроверятьОграничения");
	НовыйСчет.Записать(РежимЗаписиДокумента.Проведение);
	
	Возврат НовыйСчет.Ссылка;
	
КонецФункции

Функция ПолучитьСтруктуруОплатТарифа() Экспорт
	СоответствиеОплатТарифа = Новый Структура;
	
	СоответствиеОплатТарифа.Вставить("ОплатаСРасчетногоСчетаОтправка",
		Новый Структура("Представление, ОплатаКомментарии, НазваниеКоманды",
			НСтр("ru='Отправить с расчетного счета в банк'"),
			НСтр("ru='Рекомендуем отправить готовое платежное поручение в банк.'"),
			НСтр("ru='Отправить платежное поручение в банк'")));
	
	СоответствиеОплатТарифа.Вставить("ОплатаСРасчетногоСчетаРаспечатать",
		Новый Структура("Представление, ОплатаКомментарии, НазваниеКоманды",
			НСтр("ru='Распечатать платежное поручение'"),
			НСтр("ru='Рекомендуем распечатать готовое платежное поручение.'"),
			НСтр("ru='Распечатать платежное поручение'")));
	
	СоответствиеОплатТарифа.Вставить("ОплатаНаличными",
		Новый Структура("Представление, ОплатаКомментарии, НазваниеКоманды",
			НСтр("ru='Оплата наличными в отделении банка'"),
			НСтр("ru='Распечатайте счет на оплату выбранного тарифа и оплатите его в отделении банка. 
					 |Проследите, чтобы кассир правильно указал номер счета в назначении платежа.'"),
			НСтр("ru='Распечатать счет'")));
	
	Возврат СоответствиеОплатТарифа;
	
КонецФункции

// Функция получает табличный документ по ссылке
// 
Функция ПолучитьПрисоединенныйТабличныйДокумент(Ссылка) Экспорт
	
	РасширениеТабличногоДокумента = "mxl";
	
	МассивПрисоединенныхФайлов = Новый Массив;
	РаботаСФайлами.ЗаполнитьПрисоединенныеФайлыКОбъекту(Ссылка, МассивПрисоединенныхФайлов);
	
	Для каждого ПрисоединенныйФайл Из МассивПрисоединенныхФайлов Цикл
		
		Если ПрисоединенныйФайл.Расширение = РасширениеТабличногоДокумента Тогда
			
			ДанныеТабличногоДокумента = РаботаСФайлами.ДвоичныеДанныеФайла(ПрисоединенныйФайл);
			ИмяФайла = ПолучитьИмяВременногоФайла(РасширениеТабличногоДокумента);
			ДанныеТабличногоДокумента.Записать(ИмяФайла);
			ТабличныйДокумент = Новый ТабличныйДокумент;
			ТабличныйДокумент.Прочитать(ИмяФайла);
			
			ТабличныйДокумент.ТолькоПросмотр      = Истина;
			ТабличныйДокумент.АвтоМасштаб         = Истина;
			ТабличныйДокумент.ОриентацияСтраницы  = ОриентацияСтраницы.Портрет;
			ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
			ТабличныйДокумент.ОтображатьСетку     = Ложь;
			
			Возврат ТабличныйДокумент;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Новый ТабличныйДокумент;
	
КонецФункции

// Функция получает организацию по умолчанию
Функция ОрганизацияПоУмолчанию() Экспорт
	Возврат Справочники.Организации.ОрганизацияПоУмолчанию();
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция НайтиСоздатьУслугуПоНаименованию(Наименование, СтавкаНДС)
	
	Номенклатура = Справочники.Номенклатура.НайтиПоНаименованию(Наименование, Истина);
	
	Если ЗначениеЗаполнено(Номенклатура) Тогда
		Возврат Номенклатура;
	Иначе
		НоменклатураОбъект = Справочники.Номенклатура.СоздатьЭлемент();
	КонецЕсли;
	
	НоменклатураОбъект.Наименование = Наименование;
	
	НоменклатураОбъект.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Услуга;
	НоменклатураОбъект.СрокПополнения = 1;
	НоменклатураОбъект.СрокИсполненияЗаказа = 1;
	НоменклатураОбъект.Склад = Справочники.СтруктурныеЕдиницы.ОсновнойСклад;
	НоменклатураОбъект.СчетУчетаЗапасов = ПланыСчетов.Управленческий.СырьеИМатериалы;
	НоменклатураОбъект.СчетУчетаЗатрат = ПланыСчетов.Управленческий.КоммерческиеРасходы;
	НоменклатураОбъект.НаименованиеПолное = НоменклатураОбъект.Наименование;
	НоменклатураОбъект.ЕдиницаИзмерения = Справочники.КлассификаторЕдиницИзмерения.шт;
	НоменклатураОбъект.КатегорияНоменклатуры = Справочники.КатегорииНоменклатуры.БезКатегории;
	НоменклатураОбъект.МетодОценки = Перечисления.МетодОценкиЗапасов.ПоСредней;
	НоменклатураОбъект.НаправлениеДеятельности = Справочники.НаправленияДеятельности.ОсновноеНаправление;
	НоменклатураОбъект.СпособПополнения = Перечисления.СпособыПополненияЗапасов.Закупка;
	НоменклатураОбъект.ВидСтавкиНДС = ?(ЗначениеЗаполнено(СтавкаНДС), СтавкаНДС.ВидСтавкиНДС, Перечисления.ВидыСтавокНДС.БезНДС);
	
	НоменклатураОбъект.Записать();
	
	
	Возврат НоменклатураОбъект.Ссылка;
	
КонецФункции


#КонецОбласти

