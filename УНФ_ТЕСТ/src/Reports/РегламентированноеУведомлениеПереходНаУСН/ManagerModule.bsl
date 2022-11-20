#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеПереходНаУСН.Форма.Форма2014_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2014_1";
	Стр.ОписаниеФормы = "26.2-1/приказ ФНС от 02.11.2012 N ММВ-7-3/829@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ПечатьСразу_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат СформироватьМакет_Форма2014_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2014_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2014_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт 
	Если ИмяФормы = "Форма2014_1" Тогда 
		Данные = Объект.ДанныеУведомления.Получить();
		Данные.Вставить("Организация", Объект.Организация);
		Возврат ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор);
	КонецЕсли;
КонецФункции

Функция СформироватьМакет_Форма2014_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2014_1");
	ПараметрыМакета = МакетУведомления.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	ИННПеч = ?(ЗначениеЗаполнено(СтруктураПараметров.П_ИНН), СтруктураПараметров.П_ИНН, "-------------------------");
	КПППеч = ?(ЗначениеЗаполнено(СтруктураПараметров.П_КПП), СтруктураПараметров.П_КПП, "-------------------------");
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Объект.ДатаПодписи, "ДатаПодписи_", ПараметрыМакета, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(СтруктураПараметров.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ), "ДокументПредставителя_", ПараметрыМакета, 40, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(СтруктураПараметров.ТЕЛЕФОН), "Телефон_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(Объект.ПодписантФамилия), "ОргПодписантФамилия_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(Объект.ПодписантИмя), "ОргПодписантИмя_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(Объект.ПодписантОтчество), "ОргПодписантОтчество_", ПараметрыМакета, 20, "-");
	ПараметрыМакета.ПризнакПредставителя = ?(ЗначениеЗаполнено(СтруктураПараметров.ПРИЗНАК_НП_ПОДВАЛ), СтруктураПараметров.ПРИЗНАК_НП_ПОДВАЛ, "-");
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(СтруктураПараметров.КОД_НО), "КОД_НО_", ПараметрыМакета, 4, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(ИННПеч), "ИНН_", ПараметрыМакета, 12, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(СтруктураПараметров.ОРГАНИЗАЦИЯ), "ОрганизацияНазвание_", ПараметрыМакета, 160, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(КПППеч), "КПП_", ПараметрыМакета, 9, "-");
	
	ПараметрыМакета.ПризнакНП = ?(ЗначениеЗаполнено(СтруктураПараметров.ПРИЗНАК_НП), СтруктураПараметров.ПРИЗНАК_НП, "-");
	ПараметрыМакета.ПризнакВремениПерехода = ?(ЗначениеЗаполнено(СтруктураПараметров.КОД_ПЕРЕХОДА), СтруктураПараметров.КОД_ПЕРЕХОДА, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(СтруктураПараметров.ГОД_ПЕРЕХОДА_1), "ГОД_1_", ПараметрыМакета, 4, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(СтруктураПараметров.ДАТА_ПЕРЕХОДА, "ДатаПерехода_", ПараметрыМакета, "-");
	ПараметрыМакета.ОбъекНалогообложения = ?(ЗначениеЗаполнено(СтруктураПараметров.КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ), СтруктураПараметров.КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ВРег(СтруктураПараметров.ГОД_ПОДАЧИ_УВЕДОМЛЕНИЯ), "ГодПодачи_", ПараметрыМакета, 4, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(СтруктураПараметров.ПОЛУЧЕНО_ДОХОДОВ, "ДоходовГодПодачи_", ПараметрыМакета, 9, Ложь, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(СтруктураПараметров.ОСТАТОЧНАЯ_СТОИМОСТЬ_ОС, "СтоимостьОС_", ПараметрыМакета, 9, Ложь, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(СтруктураПараметров.ПРИЛОЖЕНО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3, Ложь, "-");
	
	ПечатнаяФорма.Вывести(МакетУведомления);
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2014_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2014_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(СведенияОтправки)
	Префикс = "SR_ZPRUSN";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2014_1(Данные, УникальныйИдентификатор)
	Титульный = Данные;
	Ошибок = 0;
	
	Если Титульный.КОД_ПЕРЕХОДА = "1" Тогда
		Если Не ЗначениеЗаполнено(Титульный.ГОД_ПЕРЕХОДА_1) Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан год перехода на УСН", УникальныйИдентификатор);
			Ошибок = Ошибок + 1;
		КонецЕсли;
	КонецЕсли;
	
	Если Титульный.КОД_ПЕРЕХОДА = "3" И (Не ЗначениеЗаполнено(Титульный.ДАТА_ПЕРЕХОДА)) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указана дата перехода на УСН", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ПРИЗНАК_НП) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан признак налогоплательщика", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_ПЕРЕХОДА) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан признак даты перехода на УСН", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан код объекта налогообложения", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Титульный.ГОД_ПОДАЧИ_УВЕДОМЛЕНИЯ) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не указан год подачи уведомления", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Если Ошибок > 0 Тогда
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
		Если ОсновныеСведения.Свойство("ИННФЛ") И ОсновныеСведения.ИННФЛ = "000000000000" Тогда 
			ОсновныеСведения.ИННФЛ = "";
		КонецЕсли;
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
	Код = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код");
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетность.НазваниеИВерсияПрограммы());
	ОсновныеСведения.Вставить("КодНО", Код);
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	ОсновныеСведения.Вставить("ПрПодп", Объект.ПодписантПризнак);
	ОсновныеСведения.Вставить("ФамилияПодп", Объект.ПодписантФамилия);
	ОсновныеСведения.Вставить("ИмяПодп", Объект.ПодписантИмя);
	ОсновныеСведения.Вставить("ОтчествоПодп", Объект.ПодписантОтчество);
	ОсновныеСведения.Вставить("НаимДок", Объект.ПодписантДокумент);
	ОсновныеСведения.Вставить("Тлф", Объект.ПодписантТелефон);
	ОсновныеСведения.Вставить("ПрПодп", Объект.ПодписантПризнак);
	
	Данные = Объект.ДанныеУведомления.Получить();
	Если Не ЗначениеЗаполнено(ОсновныеСведения.КодНО) Тогда 
		ОсновныеСведения.КодНО = Данные.КОД_НО;
	КонецЕсли;
	
	ОсновныеСведения.Вставить("ПрНП", Данные.ПРИЗНАК_НП);
	Если Данные.ПРИЗНАК_НП = 3 Тогда
		ОсновныеСведения.Вставить("Доход9М", Данные.ПОЛУЧЕНО_ДОХОДОВ);
		ОсновныеСведения.Вставить("ОстСтОснСр", Данные.ОСТАТОЧНАЯ_СТОИМОСТЬ_ОС);
	КонецЕсли;
	Если Данные.КОД_ПЕРЕХОДА = "1" Тогда
		ОсновныеСведения.Вставить("ГодПерех", Данные.ГОД_ПЕРЕХОДА_1);
	КонецЕсли;
	Если Данные.КОД_ПЕРЕХОДА = "3" Тогда
		ОсновныеСведения.Вставить("ДатаПерех", Формат(Данные.ДАТА_ПЕРЕХОДА, "ДФ=dd.MM.yyyy"));
	КонецЕсли;
	
	ОсновныеСведения.Вставить("ОбНал", Данные.КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ);
	ОсновныеСведения.Вставить("ПрДатаПер", Данные.КОД_ПЕРЕХОДА);
	ОсновныеСведения.Вставить("ГодПодач", Данные.ГОД_ПОДАЧИ_УВЕДОМЛЕНИЯ);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2014_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2014_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДанныеУведомления.Вставить("Организация", Объект.Организация);
	Ошибки = ПроверитьДокументСВыводомВТаблицу_Форма2014_1(ДанныеУведомления, УникальныйИдентификатор);
	Если Ошибки.Количество() > 0 Тогда 
		Если ДанныеУведомления.Свойство("РазрешитьВыгружатьСОшибками") И ДанныеУведомления.РазрешитьВыгружатьСОшибками = Ложь Тогда 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
			ВызватьИсключение "";
		Иначе 
			ОбщегоНазначения.СообщитьПользователю("При проверке выгрузки обнаружены ошибки. Для просмотра списка ошибок перейдите в форму уведомления, меню ""Проверка"", пункт ""Проверить выгрузку""");
		КонецЕсли;
	КонецЕсли;
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2014_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2014_1");
	ЗаполнитьДанными_Форма2014_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2014_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
КонецПроцедуры

Функция СформироватьКонтейнерДляАвтозаполнения()
	Контейнер = Новый Структура;
	Для Каждого Обл Из Отчеты.РегламентированноеУведомлениеПереходНаУСН.ПолучитьМакет("Форма2014_1").Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник 
			И Обл.СодержитЗначение = Истина
			И Обл.Защита = Ложь Тогда 
			
			Контейнер.Вставить(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Контейнер;
КонецФункции

Функция СоздатьЗаполненноеУведомление(Параметры, СуществующийДокументСсылка = Неопределено) Экспорт
	ИмяФормы = Неопределено;
	Если Не Параметры.Свойство("ИмяФормы", ИмяФормы) Тогда 
		ИмяФормы = "Форма2014_1";
	КонецЕсли;
	ИмяОтчета = "РегламентированноеУведомлениеПереходНаУСН";
	
	ПараметрыОтчета = Новый Структура();
	ПараметрыОтчета.Вставить("Организация", 			     Параметры.Организация);
	ПараметрыОтчета.Вставить("ПараметрыЗаполнения",          Параметры.ДополнительныеПараметры);
	
	Контейнер = СформироватьКонтейнерДляАвтозаполнения();
	РегламентированнаяОтчетностьПереопределяемый.ЗаполнитьОтчет(ИмяОтчета, ИмяФормы, ПараметрыОтчета, Контейнер);
	
	СтруктураПараметров = Новый Структура;
	Для Каждого КЗ Из Контейнер Цикл 
		СтруктураПараметров.Вставить(КЗ.Ключ, КЗ.Значение);
	КонецЦикла;
	
	Если ТипЗнч(СуществующийДокументСсылка) = Тип("Структура")
		И СуществующийДокументСсылка.Свойство("Ссылка")
		И ЗначениеЗаполнено(СуществующийДокументСсылка.Ссылка) Тогда 
		
		НовыйДок = СуществующийДокументСсылка.Ссылка.ПолучитьОбъект();
	ИначеЕсли ТипЗнч(СуществующийДокументСсылка) = Тип("ДокументСсылка.УведомлениеОСпецрежимахНалогообложения")
		И ЗначениеЗаполнено(СуществующийДокументСсылка) Тогда
		
		НовыйДок = СуществующийДокументСсылка.ПолучитьОбъект();
	Иначе
		НовыйДок = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
		НовыйДок.Организация = Параметры.Организация;
		НовыйДок.ИмяФормы = ИмяФормы;
		НовыйДок.ИмяОтчета = ИмяОтчета;
		НовыйДок.Дата = ТекущаяДатаСеанса();
		НовыйДок.ДатаПодписи = ТекущаяДатаСеанса();
		НовыйДок.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОПереходеНаУСН;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.ДополнительныеПараметры) = Тип("Структура") 
		И Параметры.ДополнительныеПараметры.Свойство("ПризнакПодписанта")  Тогда 
		
		ДополнительныеПараметры = Параметры.ДополнительныеПараметры;
		ПодписантПризнак = Неопределено;
		ДополнительныеПараметры.Свойство("ПризнакПодписанта", ПодписантПризнак);
		ПодписантПризнак = Строка(ПодписантПризнак);
		
		СтруктураПараметров.ПРИЗНАК_НП_ПОДВАЛ = ПодписантПризнак;
		НовыйДок.ПодписантПризнак = ПодписантПризнак;
		
		ДополнительныеПараметры.Свойство("НомерТелефонаПодписанта", СтруктураПараметров.ТЕЛЕФОН);
		ДополнительныеПараметры.Свойство("НомерТелефонаПодписанта", НовыйДок.ПодписантТелефон);
		ДополнительныеПараметры.Свойство("ФамилияПодписанта", НовыйДок.ПодписантФамилия);
		ДополнительныеПараметры.Свойство("ИмяПодписанта", НовыйДок.ПодписантИмя);
		ДополнительныеПараметры.Свойство("ОтчествоПодписанта", НовыйДок.ПодписантОтчество);
		СтруктураПараметров.ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ = СокрЛП(НовыйДок.ПодписантФамилия + " " + НовыйДок.ПодписантИмя + " " + НовыйДок.ПодписантОтчество);
		
		Если ДополнительныеПараметры.Свойство("ДатаПодписи") Тогда 
			НовыйДок.ДатаПодписи = ДополнительныеПараметры.ДатаПодписи;
			СтруктураПараметров.ДАТА_ПОДПИСИ = ДополнительныеПараметры.ДатаПодписи;
		КонецЕсли;
	КонецЕсли;
	
	НовыйДок.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	НовыйДок.Записать();
	
	Возврат НовыйДок.Ссылка;
КонецФункции

Функция ПроверитьДокументСВыводомВТаблицу_Форма2014_1(Данные, УникальныйИдентификатор)
	ТаблицаОшибок = Новый СписокЗначений;
	
	Титульный = Данные;
	Если Не ЗначениеЗаполнено(Титульный.ПРИЗНАК_НП) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан признак налогоплательщика", "Титульный", "ПРИЗНАК_НП"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.КОД_ПЕРЕХОДА) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код признака перехода на УСН", "Титульный", "КОД_ПЕРЕХОДА"));
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан код объекта налогообложения", "Титульный", "КОД_ОБЪЕКТА_НАЛОГООБЛОЖЕНИЯ"));
	КонецЕсли;
	Если (Не ЗначениеЗаполнено(Титульный.ГОД_ПОДАЧИ_УВЕДОМЛЕНИЯ)) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан год подачи уведомления", "Титульный", "ГОД_ПОДАЧИ_УВЕДОМЛЕНИЯ"));
	ИначеЕсли СтрДлина(СокрЛП(Титульный.ГОД_ПОДАЧИ_УВЕДОМЛЕНИЯ)) <> 4 Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан год подачи уведомления", "Титульный", "ГОД_ПОДАЧИ_УВЕДОМЛЕНИЯ"));
	КонецЕсли;
	
	Если Титульный.КОД_ПЕРЕХОДА = "3" И (Не ЗначениеЗаполнено(Титульный.ДАТА_ПЕРЕХОДА)) Тогда
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указана дата перехода на УСН", "Титульный", "ДАТА_ПЕРЕХОДА"));
	КонецЕсли;
	
	Если Титульный.КОД_ПЕРЕХОДА = "1" Тогда 
		Если (Не ЗначениеЗаполнено(Титульный.ГОД_ПЕРЕХОДА_1)) Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан год перехода на УСН", "Титульный", "ГОД_ПЕРЕХОДА_1"));
		ИначеЕсли СтрДлина(СокрЛП(Титульный.ГОД_ПЕРЕХОДА_1)) <> 4 Тогда 
			ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан год перехода на УСН", "Титульный", "ГОД_ПЕРЕХОДА_1"));
		КонецЕсли;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(Титульный.КОД_НО) Тогда 
		ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан налоговый орган", "Титульный", "КОД_НО"));
	КонецЕсли;
	
	Если Титульный.ПРИЗНАК_НП = 2 Или Титульный.ПРИЗНАК_НП = 3 Тогда  
		Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Данные.Организация) Тогда 
			Если Не ЗначениеЗаполнено(Титульный.П_ИНН) Или Не ЗначениеЗаполнено(Титульный.П_КПП) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН/КПП", "Титульный", "П_ИНН"));
			КонецЕсли;
			Если ЗначениеЗаполнено(Титульный.П_ИНН) И (СтрДлина(Титульный.П_ИНН) <> 10 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.П_ИНН)) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН", "Титульный", "П_ИНН"));
			КонецЕсли;
			Если ЗначениеЗаполнено(Титульный.П_КПП) И (СтрДлина(Титульный.П_КПП) <> 9 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.П_КПП)) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан КПП", "Титульный", "П_КПП"));
			КонецЕсли;
		Иначе
			Если Не ЗначениеЗаполнено(Титульный.П_ИНН) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Не указан ИНН", "Титульный", "П_ИНН"));
			КонецЕсли;
			Если ЗначениеЗаполнено(Титульный.П_ИНН) И (СтрДлина(Титульный.П_ИНН) <> 12 Или Не СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Титульный.П_ИНН)) Тогда 
				ТаблицаОшибок.Добавить(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюСтруктуруНавигацииПоОшибкам("Неправильно указан ИНН", "Титульный", "П_ИНН"));
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат ТаблицаОшибок;
КонецФункции

#КонецОбласти
#КонецЕсли